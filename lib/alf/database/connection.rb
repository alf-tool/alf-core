module Alf
  class Database
    class Connection
      include Options.helpers(:options)
      extend Forwardable

      def initialize(db, options = Options.new, &connection_handler)
        @db = db
        @options = options.freeze
        @connection_handler = connection_handler
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
        @parser = nil
        open!
      end

      def closed?
        @adapter_connection.nil?
      end

      def close
        adapter_connection.close unless closed?
        @adapter_connection = nil
        @parser = nil
      end

      ### logical level

      def parse(*args, &bl)
        parser.parse(*args, &bl)
      end

      def optimize(*args, &bl)
        optimizer.call(parse(*args, &bl))
      end

      def relvar(*args, &bl)
        optimize(*args, &bl).to_relvar
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

      ### physical level

      def_delegators :adapter_connection, :in_transaction,
                                          :knows?,
                                          :heading,
                                          :keys,
                                          :cog,
                                          :lock,
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

      def optimizer
        Optimizer.new.tap{|op|
          op.register(Optimizer::Restrict.new)
          op.register(Optimizer::Project.new)
        }
      end

      def parser
        @parser ||= options.parser.new([ options.viewpoint ], self)
      end

    end # class Connection
  end # class Database
end # module Alf
