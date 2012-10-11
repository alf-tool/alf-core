module Alf
  class Database
    class Connection
      include Options.helpers(:options)
      extend Forwardable

      def initialize(db, options = Options.new)
        @db, @options = db, options.freeze
      end
      attr_reader :db, :options


      ### logical level

      def parse(*args, &bl)
        parser.parse(*args, &bl).bind(self)
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

      def_delegators :adapter_connection, :close,
                                          :closed?,
                                          :in_transaction,
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

      def adapter_connection
        @adapter_connection ||= begin
          conn = db.adapter.connection
          conn = Adapter::Connection::SchemaCached.new(conn) if schema_cache?
          conn
        end
      end

      def compile(expr)
        compilation_chain.inject(expr){|e,c| c.call(e) }
      end

      def compilation_chain
        [ 
          Optimizer.new.register(Optimizer::Restrict.new, Algebra::Restrict),
          adapter_connection.compiler
        ]
      end

      def parser
        @parser ||= default_viewpoint.parser
      end

    end # class Connection
  end # class Database
end # module Alf
