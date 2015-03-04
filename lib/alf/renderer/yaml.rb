module Alf
  class Renderer
    #
    # Implements Alf::Renderer contract for outputing YAML files.
    #
    class YAML < ::Alf::Renderer

      def self.mime_type
        "text/yaml"
      end

      def each
        return to_enum unless block_given?
        require "yaml"
        yield("---\n")
        Engine::ToArray.new(input).each do |tuple|
          hash = Alf::Support.unsymbolize_keys(tuple.to_hash)
          yield "-" << hash.to_yaml[4..-1].gsub(/^/, "  ")[1..-1]
        end
        yield("\n")
      end

      Alf::Renderer.register(:yaml, "in YAML",  self)
    end # class YAML
  end # class Renderer
end # module Alf
