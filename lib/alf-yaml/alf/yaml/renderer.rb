module Alf
  module YAML
    #
    # Implements Alf::Renderer contract for outputing YAML files.
    #
    class Renderer < ::Alf::Renderer

      protected 

      # (see Alf::Renderer#render)
      def render(input, output)
         require "yaml"
        # TODO: refactor this to avoid loading all tuples
        # in memory
        output << input.to_a.to_yaml << "\n"
        output
      end

      Alf::Renderer.register(:yaml, "as a yaml output",  self)
    end # class Renderer
  end # module YAML
end # module Alf
