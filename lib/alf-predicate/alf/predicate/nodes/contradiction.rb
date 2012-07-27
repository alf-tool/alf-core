module Alf
  class Predicate
    module Contradiction
      include Expr

      def priority
        100
      end

    end
  end
end
