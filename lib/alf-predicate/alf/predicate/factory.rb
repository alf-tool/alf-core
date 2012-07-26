module Alf
  class Predicate
    module Factory

      def tautology
        _([:tautology, true])
      end

      def contradiction
        _([:contradiction, false])
      end

      def var_ref(name)
        _([:var_ref, name])
      end

      def and(left, right = nil)
        _([:and, _(left), _(right)])
      end

      def or(left, right = nil)
        _([:or, _(left), _(right)])
      end

      def not(operand)
        _([:not, _(operand)])
      end

      def comp(op, h)
        _([:comp, op, h])
      end

      def eq(left, right = nil)
        return comp(:eq, left) if left.is_a?(Hash) and right.nil?
        _([:eq, _(left), _(right)])
      end

      def neq(left, right = nil)
        return comp(:neq, left) if left.is_a?(Hash) and right.nil?
        _([:neq, _(left), _(right)])
      end

      def lt(left, right = nil)
        return comp(:lt, left) if left.is_a?(Hash) and right.nil?
        _([:lt, _(left), _(right)])
      end

      def lte(left, right = nil)
        return comp(:lte, left) if left.is_a?(Hash) and right.nil?
        _([:lte, _(left), _(right)])
      end

      def gt(left, right = nil)
        return comp(:gt, left) if left.is_a?(Hash) and right.nil?
        _([:gt, _(left), _(right)])
      end

      def gte(left, right = nil)
        return comp(:gte, left) if left.is_a?(Hash) and right.nil?
        _([:gte, _(left), _(right)])
      end

      def literal(literal)
        _([:literal, literal])
      end

      def native(proc)
        _([:native, proc])
      end

      def _(expr)
        case expr
        when Expr       then expr
        when TrueClass  then tautology
        when FalseClass then contradiction
        when Symbol     then var_ref(expr)
        when Proc       then native(expr)
        when Array      then Grammar.sexpr(expr)
        else
          literal(expr)
        end
      end

      extend(self)
    end # module Factory
  end # class Predicate
end # module Alf
