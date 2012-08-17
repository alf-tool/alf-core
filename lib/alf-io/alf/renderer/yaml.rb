module Alf
  class Renderer
    #
    # Implements Alf::Renderer contract for outputing YAML files.
    #
    class YAML < ::Alf::Renderer

    protected

      # (see Alf::Renderer#render)
      def render(input, output)
         require "yaml"
        # TODO: refactor this to avoid loading all tuples
        # in memory
        output << input.to_a.to_yaml << "\n"
        output
      end

      Alf::Renderer.register(:yaml, "in YAML",  self)
    end # class YAML
  end # class Renderer
end # module Alf
