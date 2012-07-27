module Alf
  class Predicate
    module Eq
      include Expr

      def priority
        50
      end

    end
  end
end
