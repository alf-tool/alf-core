module Alf
  class Renderer
    module Base
      
      # Default renderer options
      DEFAULT_OPTIONS = {}
  
      # Renderer input (typically an Iterator)
      attr_accessor :input
      
      # @return [Environment] Optional wired environment
      attr_accessor :environment
  
      # @return [Hash] Renderer's options
      attr_accessor :options
      
      #
      # Creates a reader instance. 
      #
      # @param [Iterator] iterator an Iterator of tuples to render
      # @param [Environment] environment wired environment, serving this reader
      # @param [Hash] options Reader's options (see doc of subclasses) 
      #
      def initialize(*args)
        @input, @environment, @options = case args.first
        when Array
          Tools.varargs(args, [Array, Environment, Hash])
        else
          Tools.varargs(args, [Iterator, Environment, Hash])
        end
        @options = self.class.const_get(:DEFAULT_OPTIONS).merge(@options || {}) 
      end
      
      # 
      # Sets the renderer input.
      #
      # This method mimics {Iterator#pipe} and have the same contract.
      #
      def pipe(input, env = environment)
        self.environment = env 
        self.input = input
        self
      end
  
      #
      # Executes the rendering, outputting the resulting tuples on the provided
      # output buffer. 
      #
      # The default implementation simply coerces the input as an Iterator and
      # delegates the call to {#render}.
      #
      def execute(output = $stdout)
        render(Iterator.coerce(input, environment), output)
      end
      
      protected
      
      #
      # Renders tuples served by the iterator to the output buffer provided and
      # returns the latter.
      #
      # This method must be implemented by subclasses unless {#execute} is 
      # overriden.
      #
      def render(iterator, output)
      end
      undef :render
      
    end # module Base
    include Base
  end # class Renderer
end # module Alf