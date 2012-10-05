module Alf
  module Engine
    #
    # Marker for leaf compiled nodes
    #
    class Leaf
      include Cog

      # The initial expression
      attr_reader :operand

      # Creates a Concat instance
      def initialize(operand)
        @operand = operand
      end

      # (see Cog#each)
      def each(&block)
        operand.each(&block)
      end

    end # class Leaf
  end # module Engine
end # module Alf
