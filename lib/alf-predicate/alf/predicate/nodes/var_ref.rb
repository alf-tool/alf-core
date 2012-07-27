module Alf
  class Predicate
    module VarRef
      include Expr

      def priority
        100
      end

      def var_name
        self[1]
      end

    end
  end
end
