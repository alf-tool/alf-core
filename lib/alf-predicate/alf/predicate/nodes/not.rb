module Alf
  class Predicate
    module Not
      include Expr

      def operator_symbol
        :'!'
      end

      def priority
        90
      end

      def !
        last
      end

      def free_variables
        @free_variables ||= last.free_variables
      end

      def and_split(*args, &bl)
        self.last.and_split(*args, &bl).map{|expr|
          expr.tautology? ? expr : !expr
        }
      end

    end
  end
end
