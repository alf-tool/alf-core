module Alf
  class Adapter

    class << self
      include Support::Registry

      # Register an adapter class under a specific name.
      #
      # Registered class must implement a recognizes? method that takes an array of
      # arguments; it must returns true if an adapter instance can be built using those
      # arguments, false otherwise.
      #
      # Example:
      #
      #     Connection.register(:sqlite, MySQLiteConnectionClass)
      #     Connection.sqlite(...)        # MySQLiteConnectionClass.new(...)
      #     Connection.autodetect(...)    # => MySQLiteConnectionClass.new(...)
      #
      # @see also autodetect and recognizes?
      # @param [Symbol] name name of the connection kind
      # @param [Class] clazz class that implemented the connection
      def register(name, clazz)
        super([name, clazz], Adapter)
      end

      # Auto-detect the connection class to use for specific arguments.
      #
      # This method returns an instance of the first registered Connection class that returns
      # true to an invocation of recognizes?(args). It raises an ArgumentError if no such
      # class can be found.
      #
      # @param [Object] conn_spec a connection specification
      # @return [Class] the first registered class that recognizes `conn_spec`
      # @raise [ArgumentError] when no registered class recognizes the arguments
      def autodetect(conn_spec)
        name, clazz = registered.find{|nc| nc.last.recognizes?(conn_spec) }
        unless clazz
          raise ArgumentError, "No adapter for `#{conn_spec.inspect}`"
        end
        clazz
      end

      # Automatically connects to a given database.
      #
      # @param [Hash] conn_spec a connection specification
      # @param [Module] schema a module for scope definition
      # @return [Connection] a connection instance
      def connect(conn_spec)
        clazz = autodetect(conn_spec)
        conn  = clazz.new(conn_spec)
        block_given? ? yield(conn) : conn
      ensure
        conn.close if conn and block_given?
      end

      # Returns true if _args_ can be used for get an adapter instance, false otherwise.
      #
      # When returning true, an immediate invocation of new(*args) should succeed. While
      # runtime exception are admitted (no such connection, for example), argument errors
      # should not occur (missing argument, wrong typing, etc.).
      #
      # Please be specific in the implementation of this extension point, as registered
      # connections for a chain and each of them should have a chance of being selected.
      #
      # @param [Array] args arguments for the Connection constructor
      # @return [Boolean] true if an connection may be built using `args`,
      #         false otherwise.
      def recognizes?(args)
        false
      end
    end # class << self

    # The connection specification
    attr_reader :conn_spec

    # Creates an adapter instance.
    #
    # @param [Object] conn_spec a connection specification.
    def initialize(conn_spec)
      @conn_spec = conn_spec
    end

    # Returns a low-level connection on this adapter
    def connection
      self
    end

    # Closes the connection
    def close
    end

    # Returns a compiler instance
    def compiler
      Engine::Compiler.new
    end

    ### low-level, adapter-oriented API

    # Returns true if `name` is known, false otherwise.
    def known?(name)
      raise NotSupportedError, "Unable to respond to known? `#{name}` in `#{self}`"
    end

    # Returns the heading of a given named variable
    def heading(name)
      raise NotSupportedError, "Unable to serve heading of `#{name}` in `#{self}`"
    end

    # Returns the keys of a given named variable
    def keys(name)
      raise NotSupportedError, "Unable to serve keys of `#{name}` in `#{self}`"
    end

    # Returns a cog for a given name
    def cog(name)
      raise NotSupportedError, "Unable to serve cog `#{name}` in `#{self}`"
    end

    # Yields the block in a transaction
    def in_transaction
      yield
    end

  end # class Adapter
end # module Alf
