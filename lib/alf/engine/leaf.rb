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
      def initialize(operand, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
      end

      # (see Cog#each)
      def _each
        operand.each do |tuple|
          yield(symbolize(tuple))
        end
      end

      def to_s
        "Leaf"
      end

      def inspect
        "Engine::Leaf(#{operand.inspect})"
      end

    end # class Leaf
  end # module Engine
end # module Alf
