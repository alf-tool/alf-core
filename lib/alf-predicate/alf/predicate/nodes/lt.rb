module Alf
  class Predicate
    module Lt
      include Expr

      def priority
        50
      end

    end
  end
end
