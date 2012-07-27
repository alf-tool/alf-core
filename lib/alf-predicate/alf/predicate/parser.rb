module Alf
  class Predicate
    class Parser

      def parse(input, options = {})
        raise ArgumentError, "String expected, got `#{input}`" unless input.is_a?(String)
        Factory.native(ToProc.call(input))
      end

    end # class Parser
  end # class Predicate
end # module Alf