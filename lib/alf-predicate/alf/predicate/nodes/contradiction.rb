module Alf
  class Predicate
    module Contradiction
      include Expr

      def contradiction?
        true
      end

      def !
        tautology
      end

      def priority
        100
      end

      def free_variables
        @free_variables ||= AttrList::EMPTY
      end

    end
  end
end
