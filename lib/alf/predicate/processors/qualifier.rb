module Alf
  class Predicate
    class Qualifier < Sexpr::Rewriter

      grammar Grammar

      def initialize(qualifier)
        @qualifier = qualifier
      end
      attr_reader :qualifier

      def on_identifier(sexpr)
        return sexpr unless q = qualifier[sexpr.name]
        [:qualified_identifier, q, sexpr.name]
      end

      def on_native(sexpr)
        raise NotSupportedError
      end

      alias :on_missing :copy_and_apply

    end
  end
end
