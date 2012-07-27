module Alf
  class Predicate
    module And
      include Expr

      def priority
        60
      end

    end
  end
end
