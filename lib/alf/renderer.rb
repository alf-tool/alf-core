module Alf
  #
  # Renders a relation (given by any Iterator) in a specific format.
  #
  # A renderer takes an Iterator instance as input and renders it on an output stream.
  # Renderers are **not** iterators themselves. Their usage is made via their {#execute}
  # method.
  #
  # Similarly to the {Reader} class, this one provides a registration mechanism for
  # specific output formats. The common scenario is as follows:
  #
  #   # Register a new renderer for :foo format (automatically provides the
  #   # '--foo   Render output as a foo stream' option of 'alf show') and with
  #   # the FooRenderer class for handling rendering.
  #   Renderer.register(:foo, "as a foo stream", FooRenderer)
  #
  #   # Later on, you can request a renderer instance for a specific format
  #   # as follows (wiring input is optional)
  #   r = Renderer.renderer(:foo, [an Iterator])
  #
  #   # Also, a factory method is automatically installed on the Renderer class
  #   # itself.
  #   r = Renderer.foo([an Iterator])
  #
  class Renderer

    class << self

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

    end # class << self

    # Default renderer options
    DEFAULT_OPTIONS = {}

    # Renderer input (typically an Iterator)
    attr_accessor :input

    # @return [Connection] Optional wired database
    attr_accessor :database

    # @return [Hash] Renderer's options
    attr_accessor :options

    # Creates a reader instance.
    #
    # @param [Iterator] iterator an Iterator of tuples to render
    # @param [Connection] database wired database, serving this reader
    # @param [Hash] options Reader's options (see doc of subclasses)
    def initialize(*args)
      @input, @database, @options = case args.first
      when Array
        Tools.varargs(args, [Array, Connection, Hash])
      else
        Tools.varargs(args, [Iterator, Connection, Hash])
      end
      @options = self.class.const_get(:DEFAULT_OPTIONS).merge(@options || {})
    end

    # Executes the rendering, outputting the resulting tuples on the provided
    # output buffer.
    #
    # The default implementation simply coerces the input as an Iterator and
    # delegates the call to {#render}.
    def execute(output = $stdout)
      render(Iterator.coerce(input, database), output)
    end

    protected

    # Renders tuples served by the iterator to the output buffer provided and
    # returns the latter.
    #
    # This method must be implemented by subclasses unless {#execute} is
    # overriden.
    def render(iterator, output)
    end
    undef :render

  end # class Renderer
end # module Alf
require_relative 'renderer/rash'
require_relative 'renderer/text'
require_relative 'renderer/yaml'
