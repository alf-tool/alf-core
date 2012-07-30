module Alf
  class Database

    class << self
      private :new

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
        conn = Connection.autodetect(conn_spec).new(conn_spec, helpers)
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
        @schemas ||= (superclass.schemas.dup rescue {})
      end

      # Create a named schema under the database.
      def schema(name, &bl)
        schemas[name] ||= Schema.new
        schemas[name].tap do |s|
          s.define(&bl) if bl
        end
      end

      # Returns/define the public schema
      def public_schema(&bl)
        schema(:public, &bl)
      end

      extend Forwardable
      def_delegators :public_schema, :import_native_relvars,
                                     :relvar

      # Returns the array of helper modules to use for defining the evaluation scope.
      def helpers(*helpers, &inline)
        @helpers ||= (superclass.helpers.dup rescue [])
        @helpers << Module.new(&inline) if inline
        @helpers += helpers
      end
    end

    helpers Lang::Functional

  end # module Database
end # module Alf
require_relative 'database/schema'