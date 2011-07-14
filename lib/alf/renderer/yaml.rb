require "yaml"
module Alf
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