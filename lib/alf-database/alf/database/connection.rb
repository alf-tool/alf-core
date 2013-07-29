module Alf
  class Database
    class Connection
      include Options.helpers(:options)
      extend Forwardable

      def initialize(db, options = Options.new, &connection_handler)
        @db, @options, @connection_handler = db, options.freeze, connection_handler
        open!
      end
      attr_reader :db, :options, :connection_handler

      ### connection handling
      private :connection_handler

      def adapter_connection
        @adapter_connection ||= connection_handler.call(options)
      end
      alias_method :open!, :adapter_connection
      private :open!

      def reconnect(opts = {})
        close unless (opts.keys & [:schema_cache]).empty?
        @options = options.merge(opts)
        open!
      end

      def closed?
        @adapter_connection.nil?
      end

      def close
        adapter_connection.close unless closed?
        @adapter_connection = nil
      end

      ### logical level

      def parse(*args, &bl)
        parser.parse(*args, &bl)
      end

      def optimize(*args, &bl)
        optimizer.call(parse(*args, &bl))
      end

      def relvar(*args, &bl)
        parse(*args, &bl).to_relvar
      end

      def query(*args, &bl)
        relvar(*args, &bl).to_relation
      end

      def tuple_extract(*args, &bl)
        relvar(*args, &bl).tuple_extract
      end

      def assert!(msg = "an assert! assertion failed", &bl)
        relvar(&bl).not_empty!(msg)
      end

      def deny!(msg = "a deny! assertion failed", &bl)
        relvar(&bl).empty!(msg)
      end

      def fact!(msg = "a fact! assertion failed", &bl)
        relvar(&bl).tuple_extract
      rescue NoSuchTupleError
        raise FactAssertionError, msg
      end

      ### middleware level

      def cog(expr, *args, &bl)
        case expr
        when Symbol           then adapter_connection.cog(*args.unshift(expr), &bl)
        when Algebra::Operand then compile(expr)
        else
          raise ArgumentError, "Unable to compile `#{expr}` to a cog"
        end
      end

      def lock(expr, mode = :exclusive, &bl)
        case expr
        when Symbol then adapter_connection.lock(expr, mode, &bl)
        else
          raise NotImplementedError, "Unable to lock virtual relvars"
        end
      end

      ### physical level

      def_delegators :adapter_connection, :in_transaction,
                                          :knows?,
                                          :heading,
                                          :keys,
                                          :insert,
                                          :delete,
                                          :update

      def migrate!
        adapter_connection.migrate!(options)
      end

      ### others

      def to_s
        "Alf::Database::Connection(#{adapter_connection})"
      end

    private

      def compile(expr)
        if df = options.debug_folder
          where, i = options.debug_naming.call(expr), 1
          debug_dot(expr, df/"#{where}/#{i}-Algebra.dot")
          compilation_chain.inject(expr){|e,c|
            c.call(e).tap{|mid|
              name = "#{i}-#{Alf::Support.class_name(c.class)}"
              debug_dot(mid, df/"#{where}/#{name}.dot")
              i += 1
            }
          }
        else
          compilation_chain.inject(expr){|e,c| c.call(e) }
        end
      end

      def optimizer
        Optimizer.new.register(Optimizer::Restrict.new, Algebra::Restrict)
      end

      def compilation_chain
        [ optimizer, adapter_connection.compiler ]
      end

      def parser
        options.default_viewpoint.parser(self)
      end

      def debug_dot(e, where)
        where.parent.mkdir_p
        where.open('w') do |io|
          e.to_dot(io)
        end
      rescue => ex
        $stderr.puts ex.message
        $stderr.puts ex.backtrace.join("\n")
      end

    end # class Connection
  end # class Database
end # module Alf
