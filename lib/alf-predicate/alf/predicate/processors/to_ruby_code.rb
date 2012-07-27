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
        "!" << apply(sexpr.last, sexpr)
      end

      def on_and(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(' && ')
      end

      def on_or(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(' || ')
      end

      def on_comp(sexpr)
        apply(sexpr.to_raw_expr)
      end

      def on_eq(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(" == ")
      end

      def on_neq(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(" != ")
      end

      def on_lt(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(" < ")
      end

      def on_lte(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(" <= ")
      end

      def on_gt(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(" > ")
      end

      def on_gte(sexpr)
        sexpr.sexpr_body.map{|term|
          apply(term, sexpr)
        }.join(" >= ")
      end

      def on_native(sexpr)
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
