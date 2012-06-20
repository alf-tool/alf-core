module Alf
  class Renderer
    #
    # Implements the Renderer contract through inspect
    #
    class Rash < Renderer

      # (see Renderer#render)
      def render(input, output)
        if options[:pretty]
          input.each do |tuple|
            output << "{\n" << tuple.collect{|k,v|
              "  #{lit(k)} => #{lit(v)}"
            }.join(",\n") << "\n}\n"
          end
        else
          input.each do |tuple|
            output << lit(tuple) << "\n"
          end
        end
        output
      end

      private

      def lit(x)
        Tools.to_ruby_literal(x)
      end

      Renderer.register(:rash, "as ruby hashes", self)
    end # class Rash
  end # class Renderer
end # module Alf
