module Alf
  class Predicate
    module Factory

      def tautology
        _factor([:tautology, true])
      end

      def contradiction
        _factor([:contradiction, false])
      end

      def var_ref(name)
        _factor([:var_ref, name])
      end

      def and(left, right = nil)
        _factor([:and, sexpr(left), sexpr(right)])
      end

      def or(left, right = nil)
        _factor([:or, sexpr(left), sexpr(right)])
      end

      def not(operand)
        _factor([:not, sexpr(operand)])
      end

      def comp(op, h)
        return tautology if h.empty?
        _factor([:comp, op, h])
      end

      def eq(left, right = nil)
        return comp(:eq, left) if left.is_a?(Hash) and right.nil?
        _factor([:eq, sexpr(left), sexpr(right)])
      end

      def neq(left, right = nil)
        return comp(:neq, left) if left.is_a?(Hash) and right.nil?
        _factor([:neq, sexpr(left), sexpr(right)])
      end

      def lt(left, right = nil)
        return comp(:lt, left) if left.is_a?(Hash) and right.nil?
        _factor([:lt, sexpr(left), sexpr(right)])
      end

      def lte(left, right = nil)
        return comp(:lte, left) if left.is_a?(Hash) and right.nil?
        _factor([:lte, sexpr(left), sexpr(right)])
      end

      def gt(left, right = nil)
        return comp(:gt, left) if left.is_a?(Hash) and right.nil?
        _factor([:gt, sexpr(left), sexpr(right)])
      end

      def gte(left, right = nil)
        return comp(:gte, left) if left.is_a?(Hash) and right.nil?
        _factor([:gte, sexpr(left), sexpr(right)])
      end

      def literal(literal)
        _factor([:literal, literal])
      end

      def native(proc)
        _factor([:native, proc])
      end

      def sexpr(expr)
        case expr
        when Expr       then expr
        when TrueClass  then Grammar.sexpr([:tautology, true])
        when FalseClass then Grammar.sexpr([:contradiction, false])
        when Symbol     then Grammar.sexpr([:var_ref, expr])
        when Proc       then Grammar.sexpr([:native, expr])
        when Array      then Grammar.sexpr(expr)
        else
          Grammar.sexpr([:literal, expr])
        end
      end

      def _factor(arg)
        sexpr(arg)
      end

      extend(self)
    end # module Factory
  end # class Predicate
end # module Alf
