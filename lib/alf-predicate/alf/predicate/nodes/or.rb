module Alf
  class Predicate
    module Or
      include Expr

      def priority
        60
      end

    end
  end
end
