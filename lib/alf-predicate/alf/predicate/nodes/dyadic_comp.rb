module Alf
  class Predicate
    module DyadicComp
      include Expr

      def priority
        50
      end

      def !
        Factory.send(OP_NEGATIONS[first], self[1], self[2])
      end

      def left
        self[1]
      end

      def right
        self[2]
      end

      def free_variables
        @free_variables ||= left.free_variables | right.free_variables
      end

    end
  end
end
