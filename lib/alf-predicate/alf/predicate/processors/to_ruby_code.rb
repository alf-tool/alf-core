module Alf
  class Predicate
    class ToRubyCode < Sexpr::Processor

      def on_tautology(sexpr)
        "true"
      end

      def on_contradiction(sexpr)
        "false"
      end

      def on_var_ref(sexpr)
        if s = options[:scope]
          "#{s}.#{sexpr.last.to_s}"
        else
          sexpr.last.to_s
        end
      end

      def on_not(sexpr)
        "#{sexpr.operator_symbol}" << apply(sexpr.last, sexpr)
      end

      def on_comp(sexpr)
        apply(sexpr.to_raw_expr)
      end

      def on_nadic_bool(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(" #{sexpr.operator_symbol} ")
      end
      alias :on_and :on_nadic_bool
      alias :on_or  :on_nadic_bool

      def on_dyadic(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(" #{sexpr.operator_symbol} ")
      end
      alias :on_eq  :on_dyadic
      alias :on_neq :on_dyadic
      alias :on_lt  :on_dyadic
      alias :on_lte :on_dyadic
      alias :on_gt  :on_dyadic
      alias :on_gte :on_dyadic

      def on_native(sexpr)
        proc = sexpr.to_proc
        if proc.respond_to?(:to_ruby_literal) &&
           (proc.to_ruby_literal =~ /^\s*lambda{\s*(.*?)\s*}\s*$/)
          return $1
        end
        raise NotSupportedError
      end

      def on_literal(sexpr)
        Tools.to_ruby_literal(sexpr.last)
      end

    protected

      def apply(sexpr, parent = nil)
        code = super(sexpr)
        if parent && (parent.priority >= sexpr.priority)
          code = "(" << code << ")"
        end
        code
      end

    end
  end
end
