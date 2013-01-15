module Alf
  class Reader
    #
    # Implements Alf::Reader contract for reading YAML input.
    #
    class YAML < Reader

      def self.mime_type
        "text/yaml"
      end

      def each
        return to_enum unless block_given?
        require 'yaml'
        p = ::YAML.load(input_text)
        p = [p] if TupleLike===p
        p.each do |t|
          yield Support.symbolize_keys(t)
        end
      end

      Alf::Reader.register(:yaml, [".yaml"], self)
    end # class YAML
  end # class Reader
end # module Alf
