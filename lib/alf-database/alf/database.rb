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
        return conn_spec if conn_spec.is_a?(Connection)
        conn_class = Connection.autodetect(conn_spec)
        scoping    = helpers + [ default_schema ]
        conn       = conn_class.new(conn_spec, scoping)
        block_given? ? yield(conn) : conn
      ensure
        conn.close if conn and block_given?
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
          schemas[name].tap{|s| raise NoSuchSchemaError unless s}
        end
      end

      # Sets the name of the default schema to use
      def default_schema=(name)
        @default_schema = name
      end

      # Returns/define the public schema
      def default_schema(&bl)
        schema(@default_schema || :native, &bl)
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

    def schema(name)
      Schema.new self, self.class.schema(name)
    end

    def scope(helpers = [])
      Lang::Lispy.new(self, self.class.helpers + helpers)
    end

  end # module Database
end # module Alf
require_relative 'database/schema_def'
require_relative 'database/schema'