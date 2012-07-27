module Alf
  class Predicate
    module Not
      include Expr

      def priority
        90
      end

    end
  end
end
