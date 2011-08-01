module Alf
  class Renderer
    module ClassMethods
      
      #
      # Returns registered renderers
      #
      def renderers 
        @renderers ||= []
      end
      
      #
      # Register a renderering class with a given name and description.
      #
      # Registered class must at least provide a constructor with an empty 
      # signature. The name must be a symbol which can safely be used as a ruby 
      # method name. A factory class method of that name and degelation signature 
      # is automatically installed on the Renderer class.
      #
      # @param [Symbol] name a name for the output format
      # @param [String] description an output format description (for 'alf show')
      # @param [Class] clazz Renderer subclass used to render in this format 
      #     
      def register(name, description, clazz)
        renderers << [name, description, clazz]
        (class << self; self; end).
          send(:define_method, name) do |*args|
            clazz.new(*args)
          end
      end
      
      #
      # Returns a Renderer instance for the given output format name.
      #
      # @param [Symbol] name name of an output format previously registered
      # @param [...] args other arguments to pass to the renderer constructor
      # @return [Renderer] a Renderer instance, already wired if args are 
      #         provided
      #
      def renderer(name, *args)
        if r = renderers.find{|triple| triple[0] == name}
          r[2].new(*args)
        else
          raise "No renderer registered for #{name}"
        end
      end
  
      #
      # Yields each (name,description,clazz) previously registered in turn
      #
      def each_renderer
        renderers.each(&Proc.new)
      end
      
    end # module ClassMethods
    extend(ClassMethods)
  end # class Renderer
end # module Alf
