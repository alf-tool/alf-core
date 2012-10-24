module Alf
  class Renderer
    #
    # Implements Alf::Renderer contract for outputing JSON.
    #
    class JSON < ::Alf::Renderer

      def each
        return to_enum unless block_given?
        require 'json'
        yield "["
        input.each_with_index do |t,i|
          yield ',' unless i==0
          yield ::JSON.dump(t)
        end
        yield "]\n"
      end

      Alf::Renderer.register(:json, "in JSON",  self)
    end # class JSON
  end # class Renderer
end # module Alf
