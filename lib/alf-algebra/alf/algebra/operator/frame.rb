module Alf
  module Algebra
    class Frame
      include Operator
      include Relational
      include Unary
      include WithOrdering

      signature do |s|
        s.argument :ordering, Ordering, []
        s.argument :offset,   Integer, 0
        s.argument :limit,    Integer, 25
      end

      def heading
        operand.heading
      end

      def keys
        operand.keys
      end

    end # class Frame
  end # module Algebra
end # module Alf
