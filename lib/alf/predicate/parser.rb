module Alf
  class Predicate
    class Parser

      def parse(input, options = {})
        unless input.is_a?(String)
          raise ArgumentError, "String expected, got `#{input}`"
        end
        Factory.native(input)
      end

    end # class Parser
  end # class Predicate
end # module Alf