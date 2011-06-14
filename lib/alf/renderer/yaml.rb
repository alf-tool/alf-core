require "yaml"
class Alf::Renderer
  class YAML < Alf::Renderer
    
    def execute(buffer = $stdout)
      $stdout << input.to_a.to_yaml << "\n"
    end

    def self.render(relation, buffer = "")
      new(relation).execute(buffer)
    end
    
    Alf::Renderer.register(:yaml, "as a yaml output",  self)
  end # class YAML
end # class Alf::Renderer