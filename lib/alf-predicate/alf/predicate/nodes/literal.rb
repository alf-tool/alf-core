module Alf
  class Predicate
    module Literal
      include Expr

      def priority
        100
      end

    end
  end
end
