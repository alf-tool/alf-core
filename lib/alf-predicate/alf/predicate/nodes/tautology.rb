module Alf
  class Predicate
    module Tautology
      include Expr

      def priority
        100
      end

    end
  end
end
