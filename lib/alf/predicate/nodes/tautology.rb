module Alf
  class Predicate
    module Tautology
      include Expr

      def tautology?
        true
      end

      def !
        contradiction
      end

      def &(other)
        other
      end

      def |(other)
        self
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
