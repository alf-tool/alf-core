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

      def assert!(*args, &bl)
        relvar(*args, &bl).not_empty!
      end

      def deny!(*args, &bl)
        relvar(*args, &bl).empty!
      end

      def tuple_extract(*args, &bl)
        relvar(*args, &bl).tuple_extract
      end

      def fact!(*args, &bl)
        relvar(*args, &bl).tuple_extract
      rescue NoSuchTupleError
        raise FactAssertionError
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

      ### others

      def to_s
        "Alf::Database::Connection(#{adapter_connection})"
      end

    private

      def compile(expr)
        compilation_chain.inject(expr){|e,c| c.call(e) }
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

    end # class Connection
  end # class Database
end # module Alf
