module Alf
  class Predicate
    module Lte
      include Expr

      def priority
        50
      end

    end
  end
end
