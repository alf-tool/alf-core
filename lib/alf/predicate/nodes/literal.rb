module Alf
  class Predicate
    module Literal
      include Expr

      def priority
        100
      end

      def free_variables
        @free_variables ||= AttrList::EMPTY
      end

      def value
        last
      end

    end
  end
end
