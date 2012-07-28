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

      def and_split(attr_list)
        (free_variables & attr_list).empty? ? [ tautology, self ] : [ self, tautology ]
      end

    end
  end
end
