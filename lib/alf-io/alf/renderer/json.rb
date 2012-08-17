module Alf
  class Renderer
    #
    # Implements Alf::Renderer contract for outputing JSON.
    #
    class JSON < ::Alf::Renderer

    protected

      # (see Alf::Renderer#render)
      def render(input, output)
        require "json"
        # TODO: refactor this to avoid loading all tuples
        # in memory
        output << input.to_a.to_json << "\n"
        output
      end

      Alf::Renderer.register(:json, "in JSON",  self)
    end # class JSON
  end # class Renderer
end # module Alf
