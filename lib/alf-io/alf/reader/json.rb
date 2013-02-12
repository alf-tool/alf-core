module Alf
  class Reader
    #
    # Implements Alf::Reader contract for reading JSON input.
    #
    class JSON < Reader

      def self.mime_type
        "application/json"
      end

      def each
        return to_enum unless block_given?
        require 'json'
        p = ::JSON.parse(input_text, create_additions: false)
        p = [p] if TupleLike===p
        p.each do |t|
          yield Support.symbolize_keys(t)
        end
      end

      Alf::Reader.register(:json, [".json"], self)
    end # class JSON
  end # class Reader
end # module Alf
