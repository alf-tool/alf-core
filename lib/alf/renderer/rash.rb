module Alf
  class Renderer
    #
    # Implements the Renderer contract through inspect
    #
    class Rash < Renderer
  
      # (see Renderer#render)
      def render(input, output)
        input.each do |tuple|
          output << Tools.to_ruby_literal(tuple) << "\n"
        end
        output
      end
  
      Renderer.register(:rash, "as ruby hashes", self)
    end # class Rash
  end # class Renderer
end # module Alf
