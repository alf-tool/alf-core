module Alf
  class Predicate
    class Renamer < Sexpr::Rewriter

      grammar Grammar

      def on_identifier(sexpr)
        return sexpr unless new_name = options[:renaming][sexpr.name]
        return new_name if Sexpr===new_name
        [:identifier, new_name]
      end

      def on_qualified_identifier(sexpr)
        return sexpr unless new_name = options[:renaming][sexpr.name]
        return new_name if Sexpr===new_name
        [:qualified_identifier, sexpr.qualifier, new_name]
      end

      def on_native(sexpr)
        raise NotSupportedError
      end

      alias :on_missing :copy_and_apply

    end
  end
end
