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
        first = true
        output << "["
        input.each do |t|
          output << "," unless first
          output << ::JSON.fast_generate(t)
          first = false
        end
        output << "]"
        output
      end

      Alf::Renderer.register(:json, "in JSON",  self)
    end # class JSON
  end # class Renderer
end # module Alf
