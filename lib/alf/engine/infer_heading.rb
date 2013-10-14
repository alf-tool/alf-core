module Alf
  module Engine
    #
    # Infers the heading of the iterated relation.
    #
    class InferHeading
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      def initialize(operand, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
      end

      def _each
        heading = operand.inject(Alf::Heading::EMPTY){|h,t| h + heading(t) }
        yield(heading.to_h)
      end

    private

      def heading(tuple)
        Alf::Heading[Hash[tuple.map{|k,v| [k, v.class]}]]
      end

    end
  end
end
