module Alf
  class Database

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

      # Returns the defined schemas (by name in a Hash)
      def schemas
        @schemas ||= begin
          schemas = superclass.schemas.dup rescue {:native => SchemaDef.native}
          Hash[schemas.map{|name,s| [name, s.dup] }]
        end
      end

      # Create a named schema under the database.
      def schema(name, &bl)
        if bl
          schemas[name] ||= SchemaDef.new
          schemas[name].define(&bl)
        else
          schemas[name].tap{|s|
            raise NoSuchSchemaError, "No such schema `#{name}`" unless s
          }
        end
      end

      # Sets the name of the default schema to use
      def default_schema=(name)
        @default_schema = name
      end

      # Returns the name of the default schema to use
      def default_schema_name
        @default_schema || :native
      end

      # Returns/define the public schema
      def default_schema(&bl)
        schema(default_schema_name, &bl)
      end

      extend Forwardable
      def_delegators :default_schema, :relvar

      # Returns the array of helper modules to use for defining the evaluation scope.
      def helpers(*helpers, &inline)
        @helpers ||= (superclass.helpers.dup rescue [])
        @helpers << Module.new(&inline) if inline
        @helpers += helpers
      end
    end

    helpers Lang::Functional

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
      schema self.class.default_schema_name
    end

    extend Forwardable
    def_delegators :default_schema, :parse,
                                    :query,
                                    :relvar

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

    # @api private
    def scope(helpers = [])
      Lang::Lispy.new(self, helpers + self.class.helpers)
    end

    def to_s
      "Alf::Database(#{connection})"
    end

  end # module Database
end # module Alf
require_relative 'database/schema_def'
require_relative 'database/schema'