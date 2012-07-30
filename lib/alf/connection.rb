module Alf
  #
  # A connection encapsulates the interface with the outside world, providing base iterators
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

    class << self
      include Tools::Registry

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

    # The scope that defines the global database scope
    attr_reader :scope

    # Creates an connection instance, wired to the specified folder.
    #
    # @param [String] folder path to the folder to use as dataset source.
    def initialize(conn_spec)
      @conn_spec = conn_spec
    end

    # Closes this connection, freeing resources if needed.
    #
    # @return [undefined]
    def close
    end

    # Returns an optimizer instance
    def optimizer
      Optimizer.new.
                register(Optimizer::Restrict.new, Operator::Relational::Restrict)
    end

    # Returns a compiler instance
    def compiler
      Engine::Compiler.new
    end

    # Returns a low-level Iterator for a given named variable
    def iterator(name)
      raise NotImplementedError, "Unable to serve `#{name}` in Connection.iterator"
    end

    # Returns the heading of a given named variable
    def heading(name)
      raise NotSupportedError, "Unable to infer heading for `#{name}`"
    end

    # Returns the keys of a given named variable
    def keys(name)
      raise NotSupportedError, "Unable to infer keys for `#{name}`"
    end

    # Returns a native schema instance
    def native_schema_def
    end

  end # class Connection
end # module Alf
require_relative 'connection/folder'
