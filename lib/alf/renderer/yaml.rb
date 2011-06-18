require "yaml"
module Alf
  module Iterator
    
    def to_yaml(*args, &block)
      to_a.to_yaml(*args, &block)
    end
    
  end
  class Renderer::YAML < Renderer
    
    protected 
    
    # (see Alf::Renderer#render)
    def render(input, output)
      output << input.to_a.to_yaml << "\n"
      output
    end

    Renderer.register(:yaml, "as a yaml output",  self)
  end # class YAML
end # module Alf