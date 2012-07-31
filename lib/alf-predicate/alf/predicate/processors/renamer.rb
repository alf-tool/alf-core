module Alf
  class Predicate
    class Renamer < Sexpr::Rewriter

      grammar Grammar

      def on_var_ref(sexpr)
        [:var_ref, options[:renaming][sexpr.var_name] || sexpr.var_name]
      end

      def on_native(sexpr)
        raise NotSupportedError
      end

      alias :on_missing :copy_and_apply

    end
  end
end
