module Alf
  class Renderer
    #
    # Implements Alf::Renderer contract for outputing JSON.
    #
    class JSON < ::Alf::Renderer

      def self.mime_type
        "application/json"
      end

      def each
        return to_enum unless block_given?
        require 'json'
        i = 0
        yield "["
        input.each do |t|
          yield ',' unless i==0
          yield ::JSON.dump(t)
          i += 1
        end
        yield "]\n"
      end

      Alf::Renderer.register(:json, "in JSON",  self)
    end # class JSON
  end # class Renderer
end # module Alf
