module Alf
  class Predicate
    module Native
      include Expr

      def priority
        90
      end

      def to_proc
        self[1]
      end

    end
  end
end
