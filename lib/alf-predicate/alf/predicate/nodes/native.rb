module Alf
  class Predicate
    module Native
      include Expr

      def priority
        90
      end

      def to_proc(options = {})
        self[1]
      end

    end
  end
end
