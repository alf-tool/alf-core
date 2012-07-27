module Alf
  class Predicate
    module Native
      include Expr

      def priority
        90
      end

    end
  end
end
