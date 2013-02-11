module Alf
  class Renderer
    #
    # Implements the Renderer contract through inspect
    #
    class Rash < Renderer

      def self.mime_type
        nil
      end

      def each
        return to_enum unless block_given?
        if options[:pretty]
          each_tuple do |tuple|
            yield "{\n" << tuple.map{|k,v| "  #{l(k)} => #{l(v)}"}.join(",\n") << "\n}\n"
          end
        else
          each_tuple do |tuple|
            yield to_rash(tuple) << "\n"
          end
        end
      end

    private

      def l(x)
        Support.to_ruby_literal(x)
      end

      def to_rash(x)
        l(x.is_a?(Tuple) ? x.to_hash : x)
      end

      Renderer.register(:rash, "as ruby hashes", self)
    end # class Rash
  end # class Renderer
end # module Alf
