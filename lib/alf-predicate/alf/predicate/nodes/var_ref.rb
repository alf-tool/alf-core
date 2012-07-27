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

      def and_split(attr_list, reverse = false)
        res = attr_list.include?(var_name) ? [ self, tautology ] : [ tautology, self ]
        reverse ? res.reverse : res
      end

    end
  end
end
