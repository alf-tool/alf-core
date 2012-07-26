require_relative 'adapter/internal'
require_relative 'adapter/external'
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
    include Internal
    include External

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

  end # class Adapter
end # module Alf
require_relative 'adapter/folder'
