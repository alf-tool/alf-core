module Alf
  class Predicate
    module VarRef
      include Expr

      def priority
        100
      end

    end
  end
end
