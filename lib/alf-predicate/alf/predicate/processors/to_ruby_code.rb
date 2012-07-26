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
        sexpr.last.to_s
      end

      def on_not(sexpr)
        "!#{apply(sexpr.last)}"
      end

      def on_and(sexpr)
        sexpr_body.map{|term|
          "(#{apply(term)})"
        }.join(' && ')
      end

      def on_or(sexpr)
        sexpr_body.map{|term|
          "(#{apply(term)})"
        }.join(' || ')
      end

      def on_comp(sexpr)
        apply(sexpr.to_raw_expr)
      end

      def on_eq(sexpr)
        sexpr_body.map{|term| "#{apply(term)}"}.join("==")
      end

      def on_neq(sexpr)
        sexpr_body.map{|term| "#{apply(term)}"}.join("!=")
      end

      def on_lt(sexpr)
        sexpr_body.map{|term| "#{apply(term)}"}.join("<")
      end

      def on_lte(sexpr)
        sexpr_body.map{|term| "#{apply(term)}"}.join("<=")
      end

      def on_gt(sexpr)
        sexpr_body.map{|term| "#{apply(term)}"}.join(">")
      end

      def on_gte(sexpr)
        sexpr_body.map{|term| "#{apply(term)}"}.join(">=")
      end

      def on_native(sexpr)
        raise NotSupportedError
      end

      def on_literal(sexpr)
        Tools.to_ruby_literal(sexpr.last)
      end

    end
  end
end
