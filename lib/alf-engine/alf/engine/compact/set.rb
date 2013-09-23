module Alf
  module Engine
    #
    # Remove duplicate tuples through an in-memory `to_set` heuristics.
    #
    class Compact::Set
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # Creates a Compact::Set instance
      def initialize(operand, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
      end

      # (see Cog#each)
      def _each(&block)
        operand.to_set.each(&block)
      end

    end # class Compact::Set
  end # module Engine
end # module Alf
