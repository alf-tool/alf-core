module Alf
  class Database
    require_relative 'database/schema_def_methods'
    require_relative 'database/schema_def'
    require_relative 'database/schema'

    # About connections
    class << self

      # Connects to a database, auto-detecting the connection to use.
      #
      # This method returns an Connection instance connected to the underlying database.
      # It raises an ArgumentError if no such connection can be found.
      #
      # @param [Object] conn_spec a connection specification
      # @return [Connection] an connection instance
      # @raise [ArgumentError] when no registered connection recognizes the arguments
      def connect(conn_spec)
        conn_spec = Connection.autodetect(conn_spec).new(conn_spec) unless conn_spec.is_a?(Connection)
        db        = new(conn_spec)
        block_given? ? yield(db) : db
      ensure
        db.disconnect if db and block_given?
      end

      def folder(*args, &bl)
        connect(Connection.folder(*args), &bl)
      end

      # Returns Alf's default database
      #
      # @return [Database] the default database instance.
      def default(&bl)
        connect(Connection.folder('.'), &bl)
      end

      # Returns a database instance on Alf's examples
      #
      # @return [Database] a database instance on Alf's examples.
      def examples(&bl)
        connect(Connection.folder Path.backfind('examples/operators'), &bl)
      end
    end

    # About schema definitions
    class << self

      def build_toplevel_schema
        SchemaDef.new(self){
          schema(:native){ import_native_relvars }
        }
      end

      def toplevel_schema
        @toplevel_schema ||= build_toplevel_schema
      end

      extend Forwardable
      def_delegators :toplevel_schema, :schema,
                                       :helpers

      def relvar(*args, &bl)
        toplevel_schema.schema(:native).relvar(*args, &bl)
      end
    end

    # About scope
    class << self

      def scope(database, with = [])
        Lang::Lispy.new(database, [ toplevel_schema.to_scope_module ] + with + [ Lang::Functional ])
      end
    end


    # The underlying connection
    attr_reader :connection

    # Creates a new database instance
    def initialize(connection)
      @connection = connection
    end

    def disconnect
      @connection.close if @connection
    ensure
      @connection = nil
    end

    def schema(name)
      Schema.new self, self.class.schema(name)
    end

    def default_schema
      schema(:native)
    end

    extend Forwardable
    def_delegators :default_schema, :parse,
                                    :query,
                                    :relvar,
                                    :tuple_extract

    def optimize(*args, &bl)
      optimizer.call parse(*args, &bl)
    end

    def_delegators :connection, :heading,
                                :keys,
                                :iterator,
                                :optimizer,
                                :compiler,
                                :native_schema_def,
                                :in_transaction,
                                :insert,
                                :delete,
                                :update

    def scope
      self.class.scope(self)
    end

    def to_s
      "Alf::Database(#{connection})"
    end

  end # module Database
end # module Alf
