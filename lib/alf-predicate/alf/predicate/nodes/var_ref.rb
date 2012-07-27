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

      def free_variables
        @free_variables ||= AttrList[ var_name ]
      end

    end
  end
end
