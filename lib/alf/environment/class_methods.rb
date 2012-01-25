module Alf
  class Environment
    #
    # Installs class-level methods for Alf environments.
    #
    module ClassMethods

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
        folder File.expand_path('../../../../examples/operators', __FILE__)
      end

    end # module ClassMethods
    extend(ClassMethods)
  end # class Environment
end # module Alf
