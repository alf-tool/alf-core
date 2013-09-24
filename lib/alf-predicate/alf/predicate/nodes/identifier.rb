module Alf
  class Predicate
    module Identifier
      include Expr

      def priority
        100
      end

      def name
        self[1]
      end

      def free_variables
        @free_variables ||= AttrList[ name ]
      end

    end
  end
end
