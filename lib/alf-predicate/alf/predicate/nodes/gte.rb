module Alf
  class Predicate
    module Gte
      include Expr

      def priority
        50
      end

    end
  end
end
