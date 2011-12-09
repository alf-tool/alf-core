module Alf
  #
  # Renders a relation (given by any Iterator) in a specific format.
  #
  # A renderer takes an Iterator instance as input and renders it on an output
  # stream. Renderers are **not** iterators themselves. Their usage is made 
  # via their {#execute} method.
  #
  # Similarly to the {Reader} class, this one provides a registration mechanism
  # for specific output formats. The common scenario is as follows:
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
    require 'alf/renderer/class_methods'
    require 'alf/renderer/instance_methods'
    require 'alf/renderer/rash'
    require 'alf/renderer/text'

  end # class Renderer
end # module Alf
