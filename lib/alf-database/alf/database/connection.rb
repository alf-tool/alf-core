module Alf
  class Database
    class Connection
      extend Forwardable

      def initialize(db, low_connection, viewpoint = Viewpoint::NATIVE)
        @db = db
        @low_connection = low_connection
        @viewpoint = viewpoint
      end

      def_delegators :'@low_connection', :close,
                                         :closed?,
                                         :in_transaction,
                                         :knows?,
                                         :heading,
                                         :keys,
                                         :cog,
                                         :insert,
                                         :delete,
                                         :update

      def compile(expr)
        compilation_chain.inject(expr){|e,c| c.call(e) }
      end

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

      def to_s
        "Alf::Database::Connection(#{@low_connection})"
      end

    private

      def compilation_chain
        [ 
          Optimizer.new.register(Optimizer::Restrict.new, Algebra::Restrict),
          @low_connection.compiler
        ]
      end

      def parser
        @parser ||= @viewpoint.parser
      end

    end # class Connection
  end # class Database
end # module Alf
