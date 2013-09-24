module Alf
  class Predicate
    class Renamer < Sexpr::Rewriter

      grammar Grammar

      def on_identifier(sexpr)
        [:identifier,
          options[:renaming][sexpr.name] || sexpr.name]
      end

      def on_qualified_identifier(sexpr)
        [:qualified_identifier,
          sexpr.qualifier,
          options[:renaming][sexpr.name] || sexpr.name]
      end

      def on_native(sexpr)
        raise NotSupportedError
      end

      alias :on_missing :copy_and_apply

    end
  end
end
