require "yaml"
class Alf::Renderer
  class YAML < Alf::Renderer
    
    protected 
    
    def render(intput, output)
      output << input.to_a.to_yaml << "\n"
    end

    Alf::Renderer.register(:yaml, "as a yaml output",  self)
  end # class YAML
end # class Alf::Renderer