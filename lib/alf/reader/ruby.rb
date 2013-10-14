module Alf
  class Reader
    #
    # Specialization of the Reader contract for .rb files.
    #
    # A .rb file/stream contains some ruby code that evaluates to a Relation-like
    # object, typically an Array of hashes.
    #
    class Ruby < Reader

      def self.mime_type
        nil
      end

      def each(&bl)
        return to_enum unless block_given?
        ::Kernel.eval(input_text).each(&bl)
      end

      Reader.register(:ruby, [".rb", ".ruby"], self)
    end # class Ruby
  end # class Reader
end # module Alf
