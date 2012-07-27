module Alf
  class Predicate
    module Neq
      include Expr

      def priority
        50
      end

    end
  end
end
