module Alf
  #
  # An environment encapsulates the interface with the outside world, providing
  # base iterators for named datasets.
  #
  # An environment is typically obtained through the factory defined by this
  # class:
  #
  #   # Returns the default environment (examples, for now)
  #   Alf::Environment.default
  #
  #   # Returns an environment on Alf's examples
  #   Alf::Environment.examples
  #
  #   # Returns an environment on a specific folder, automatically
  #   # resolving datasources via recognized file extensions (see Reader)
  #   Alf::Environment.folder('path/to/a/folder')
  #
  # You can implement your own environment by subclassing this class and
  # implementing the {#dataset} method. As additional support is implemented
  # in the base class, Environment should never be mimiced.
  #
  # This class provides an extension point allowing to participate to auto
  # detection and resolving of the --env=... option when alf is used in shell.
  # See Environment.register, Environment.autodetect and Environment.recognizes?
  # for details.
  #
  class Environment

    class << self

      # Returns registered environments
      #
      # @return [Array<Environment>] registered environments.
      def environments
        @environments ||= []
      end

      # Register an environment class under a specific name.
      #
      # Registered class must implement a recognizes? method that takes an array
      # of arguments; it must returns true if an environment instance can be
      # built using those arguments, false otherwise.
      #
      # Example:
      #
      #     Environment.register(:sqlite, MySQLiteEnvClass)
      #     Environment.sqlite(...)        # MySQLiteEnvClass.new(...)
      #     Environment.autodetect(...)    # => MySQLiteEnvClass.new(...)
      #
      # @see also autodetect and recognizes?
      # @param [Symbol] name name of the environment kind
      # @param [Class] clazz class that implemented the environment
      def register(name, clazz)
        environments << [name, clazz]
        (class << self; self; end).
          send(:define_method, name) do |*args|
            clazz.new(*args)
          end
      end

      # Auto-detect the environment to use for specific arguments.
      #
      # This method returns an instance of the first registered Environment
      # class that returns true to an invocation of recognizes?(args). It raises
      # an ArgumentError if no such class can be found.
      #
      # @param [Array] args arguments for the Environment constructor
      # @return [Environment] an environment instance
      # @raise [ArgumentError] when no registered class recognizes the arguments
      def autodetect(*args)
        if (args.size == 1) and args.first.is_a?(Environment)
          return args.first
        else
          name, clazz = environments.find{|nc| nc.last.recognizes?(args)}
          return clazz.new(*args) if clazz
        end
        envs = environments.map{|r| r.last.name}.join(', ')
        raise ArgumentError, "Unable to auto-detect Environment with #{args.inspect} [#{envs}]"
      end
      alias :coerce :autodetect

      # Returns true _args_ can be used for building an environment instance,
      # false otherwise.
      #
      # When returning true, an immediate invocation of new(*args) should
      # succeed. While runtime exception are admitted (no such database, for
      # example), argument errors should not occur (missing argument, wrong
      # typing, etc.).
      #
      # Please be specific in the implementation of this extension point, as
      # registered environments for a chain and each of them should have a
      # chance of being selected.
      #
      # @param [Array] args arguments for the Environment constructor
      # @return [Boolean] true if an environment may be built using `args`,
      #         false otherwise.
      def recognizes?(args)
        false
      end

      # Returns Alf's default environment
      #
      # @return [Environment] the default environment instance.
      def default
        examples
      end

      # Returns an environment on Alf's examples
      #
      # @return [Environment] an environment on Alf's examples.
      def examples
        folder File.expand_path('../../../examples/operators', __FILE__)
      end

    end # class << self

    # Returns a dataset whose name is provided.
    #
    # This method resolves named datasets to tuple enumerables. When the
    # dataset exists, this method must return an Iterator, typically a
    # Reader instance. Otherwise, it must throw a NoSuchDatasetError.
    #
    # @param [Symbol] name the name of a dataset
    # @return [Iterator] an iterator, typically a Reader instance
    # @raise [NoSuchDatasetError] when the dataset does not exists
    def dataset(name)
    end
    undef :dataset

  end # class Environment
end # module Alf
require_relative 'environment/folder'
