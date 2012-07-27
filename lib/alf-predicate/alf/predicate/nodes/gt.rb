module Alf
  class Predicate
    module Gt
      include Expr

      def priority
        50
      end

    end
  end
end
