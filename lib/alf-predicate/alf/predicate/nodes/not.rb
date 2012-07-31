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

    end
  end
end
