module Alf
  #
  # A connection encapsulates the interface with the outside world, providing base cogs
  # for named datasets.
  #
  # You can implement your own connection by subclassing this class and implementing the
  # {#base_relvar} method. As additional support is implemented in the base class, 
  # Connection should never be mimiced.
  #
  # This class provides an extension point allowing to participate to auto detection and
  # resolving of the --db=... option when alf is used in shell. See Connection.register,
  # Connection.autodetect and Connection.recognizes? for details.
  #
  class Connection
    extend Forwardable

    class << self
      include Support::Registry

      # Register an connection class under a specific name.
      #
      # Registered class must implement a recognizes? method that takes an array of
      # arguments; it must returns true if an connection instance can be built using those
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
        super([name, clazz], Connection)
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
          raise ArgumentError, "No connection for `#{conn_spec.inspect}`"
        end
        clazz
      end

      # Automatically connects to a given database.
      #
      # @param [Hash] conn_spec a connection specification
      # @param [Module] schema a module for scope definition
      # @return [Connection] a connection instance
      def connect(conn_spec, schema = Schema.native)
        clazz = autodetect(conn_spec)
        conn  = clazz.new(conn_spec, schema)
        block_given? ? yield(conn) : conn
      ensure
        conn.close if conn and block_given?
      end

      # Returns true _args_ can be used for building an connection instance,
      # false otherwise.
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

    # Creates an connection instance, wired to the specified folder.
    #
    # @param [String] folder path to the folder to use as dataset source.
    def initialize(conn_spec, schema = Schema.native)
      @conn_spec = conn_spec
      @schema    = schema
    end

    # Closes this connection, freeing resources if needed.
    #
    # @return [undefined]
    def close
    end

    # Alias for close
    def disconnect
      close
    end

    ### high-level user-oriented API

    def scope
      Lang::Lispy.new(self, [ @schema ])
    end

    def_delegators :scope, :parse,
                           :query,
                           :relvar,
                           :optimize,
                           :compile,
                           :assert!,
                           :deny!,
                           :fact!,
                           :tuple_extract

    ### third-party helpers

    # Returns an optimizer instance
    def optimizer
      Optimizer.new.register(Optimizer::Restrict.new, Algebra::Restrict)
    end

    # Returns a compiler instance
    def compiler
      Engine::Compiler.new
    end

    ### low-level, adapter-oriented API

    # Returns true if `name` is known, false otherwise
    def known?(name)
      !cog(name).nil? rescue false
    end

    # Returns a cog for a given name
    def cog(name)
      raise NotSupportedError, "Unable to serve cog `#{name}` in `#{self}`"
    end

    # Returns the heading of a given named variable
    def heading(name)
      raise NotSupportedError, "Unable to serve heading of `#{name}` in `#{self}`"
    end

    # Returns the keys of a given named variable
    def keys(name)
      raise NotSupportedError, "Unable to serve keys of `#{name}` in `#{self}`"
    end

    # Yields the block in a transaction
    def in_transaction
      yield
    end

  end # class Connection
end # module Alf
require_relative 'connection/folder'
