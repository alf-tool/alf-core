module Alf
  module Engine
    #
    # Remove duplicate tuples through an in-memory `to_set` heuristics.
    #
    class Compact::Set < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # Creates a Compact::Set instance
      def initialize(operand)
        @operand = operand
      end

      # (see Cog#each)
      def each(&block)
        operand.to_set.each(&block)
      end

    end # class Compact::Set
  end # module Engine
end # module Alf
