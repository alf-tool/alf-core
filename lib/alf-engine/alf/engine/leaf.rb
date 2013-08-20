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
      def initialize(operand, expr = nil)
        super(expr)
        @operand = operand
      end

      # (see Cog#each)
      def _each(&block)
        operand.each(&block)
      end

      def to_s
        "Engine::Leaf(#{operand})"
      end

    end # class Leaf
  end # module Engine
end # module Alf
