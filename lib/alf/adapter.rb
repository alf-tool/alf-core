module Alf
  #
  # An adapter encapsulates the interface with the outside world, providing base iterators
  # for named datasets.
  #
  # You can implement your own adapter by subclassing this class and implementing the
  # {#relvar} method. As additional support is implemented in the base class, Adapter
  # should never be mimiced.
  #
  # This class provides an extension point allowing to participate to auto detection and
  # resolving of the --db=... option when alf is used in shell. See Adapter.register,
  # Adapter.autodetect and Adapter.recognizes? for details.
  #
  class Adapter

    class << self
      include Tools::Registry

      # Register an adapter class under a specific name.
      #
      # Registered class must implement a recognizes? method that takes an array of
      # arguments; it must returns true if an adapter instance can be built using those
      # arguments, false otherwise.
      #
      # Example:
      #
      #     Adapter.register(:sqlite, MySQLiteAdapterClass)
      #     Adapter.sqlite(...)        # MySQLiteAdapterClass.new(...)
      #     Adapter.autodetect(...)    # => MySQLiteAdapterClass.new(...)
      #
      # @see also autodetect and recognizes?
      # @param [Symbol] name name of the adapter kind
      # @param [Class] clazz class that implemented the adapter
      def register(name, clazz)
        super([name, clazz], Adapter)
      end

      # Auto-detect the adapter to use for specific arguments.
      #
      # This method returns an instance of the first registered Adapter class that returns
      # true to an invocation of recognizes?(args). It raises an ArgumentError if no such
      # class can be found.
      #
      # @param [Array] args arguments for the Adapter constructor
      # @return [Adapter] an adapter instance
      # @raise [ArgumentError] when no registered class recognizes the arguments
      def autodetect(*args)
        if (args.size == 1) and args.first.is_a?(Adapter)
          return args.first
        else
          name, clazz = registered.find{|nc|
            nc.last.recognizes?(args)
          }
          return clazz.new(*args) if clazz
        end
        raise ArgumentError, "Unable to auto-detect Adapter with (#{args.map(&:inspect).join(', ')})"
      end
      alias :coerce :autodetect

      # Returns true _args_ can be used for building an adapter instance,
      # false otherwise.
      #
      # When returning true, an immediate invocation of new(*args) should succeed. While
      # runtime exception are admitted (no such adapter, for example), argument errors
      # should not occur (missing argument, wrong typing, etc.).
      #
      # Please be specific in the implementation of this extension point, as registered
      # adapters for a chain and each of them should have a chance of being selected.
      #
      # @param [Array] args arguments for the Adapter constructor
      # @return [Boolean] true if an adapter may be built using `args`,
      #         false otherwise.
      def recognizes?(args)
        false
      end
    end # class << self

    # Closes a given connection, freeing resources if needed.
    #
    # @param [Connection] connection a connection previously obtained.
    def close(connection)
    end

    # Returns a relvar whose name is provided.
    #
    # @arg    [Symbol] name the name of a relation variable.
    # @return [Relvar] a relation variable.
    # @raise  [NoSuchRelvarError] when the variable does not exist.
    def relvar(name)
      raise NotImplementedError
    end

  end # class Adapter
end # module Alf
require_relative 'adapter/folder'
