module Alf
  class Environment
    module ClassMethods

      #
      # Returns registered environments
      #
      def environments
        @environments ||= []
      end
      
      #
      # Register an environment class under a specific name. 
      #
      # Registered class must implement a recognizes? method that takes an array
      # of arguments; it must returns true if an environment instance can be built
      # using those arguments, false otherwise. Please be very specific in the 
      # implementation for returning true. See also autodetect and recognizes?
      #
      # @param [Symbol] name name of the environment kind
      # @param [Class] clazz class that implemented the environment
      #
      def register(name, clazz)
        environments << [name, clazz]
        (class << self; self; end).
          send(:define_method, name) do |*args|
            clazz.new(*args)
          end
      end
      
      #
      # Auto-detect the environment to use for specific arguments.
      #
      # This method returns an instance of the first registered Environment class 
      # that returns true to an invocation of recognizes?(args). It raises an 
      # ArgumentError if no such class can be found.    
      #
      # @return [Environment] an environment instance
      # @raise [ArgumentError] when no registered class recognizes the arguments
      #
      def autodetect(*args)
        if (args.size == 1) && args.first.is_a?(Environment)
          return args.first
        else
          environments.each do |name,clazz|
            return clazz.new(*args) if clazz.recognizes?(args)
          end
        end
        raise ArgumentError, "Unable to auto-detect Environment with #{args.inspect}"
      end
      
      #
      # (see Environment.autodetect)
      #
      def coerce(*args)
        autodetect(*args)
      end
      
      #
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
      def recognizes?(args)
        false
      end
      
      #
      # Returns the default environment
      #
      def default
        examples
      end
      
      #
      # Returns the examples environment
      #
      def examples
        folder File.expand_path('../../../../examples/operators', __FILE__)
      end
    
    end # module ClassMethods
    extend(ClassMethods)
  end # class Environment
end # module Alf