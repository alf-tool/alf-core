module Alf
  class Predicate
    module DyadicComp
      include Expr

      def priority
        50
      end

      def !
        Factory.send(OP_NEGATIONS[first], last)
      end

    end
  end
end
