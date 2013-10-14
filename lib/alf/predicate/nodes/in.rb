module Alf
  class Predicate
    module In
      include Expr

      def priority
        80
      end

      def identifier
        self[1]
      end

      def values
        self[2]
      end

      def free_variables
        @free_variables ||= identifier.free_variables
      end

      def constant_variables
        values.size == 1 ? free_variables : AttrList::EMPTY
      end

    end
  end
end
