module Alf
  class Predicate
    module Tautology
      include Expr

      def tautology?
        true
      end

      def priority
        100
      end

    end
  end
end
