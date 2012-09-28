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
            output << "{\n" << tuple.map{|k,v|
              "  #{lit(k)} => #{lit(v)}"
            }.join(",\n") << "\n}\n"
          end
        else
          input.each do |tuple|
            output << to_rash(tuple) << "\n"
          end
        end
        output
      end

      private

      def lit(x)
        Support.to_ruby_literal(x)
      end

      def to_rash(x)
        x = x.to_hash if x.is_a?(Tuple)
        lit(x)
      end

      Renderer.register(:rash, "as ruby hashes", self)
    end # class Rash
  end # class Renderer
end # module Alf
