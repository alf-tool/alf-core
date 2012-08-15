module Alf
  class Predicate
    module Factory

      def tautology
        _factor_predicate([:tautology, true])
      end

      def contradiction
        _factor_predicate([:contradiction, false])
      end

      def var_ref(name)
        _factor_predicate([:var_ref, name])
      end

      def and(left, right = nil)
        _factor_predicate([:and, sexpr(left), sexpr(right)])
      end

      def or(left, right = nil)
        _factor_predicate([:or, sexpr(left), sexpr(right)])
      end

      def not(operand)
        _factor_predicate([:not, sexpr(operand)])
      end

      def relation(r)
        tuples = r.to_a
        case tuples.size
        when 0 then contradiction
        when 1 then eq(tuples.first)
        else
          if tuples.first.size==1
            k = tuples.first.keys.first
            self.in(k, tuples.map{|t| t[k]})
          else
            tuples.inject(contradiction){|p,t| p | eq(t) }
          end
        end
      end

      def in(var_ref, values)
        var_ref = sexpr(var_ref) if var_ref.is_a?(Symbol)
        _factor_predicate([:in, var_ref, values])
      end

      def comp(op, h)
        if h.empty?
          return tautology
        elsif h.size==1
          _factor_predicate [op, sexpr(h.keys.first), sexpr(h.values.last)]
        else
          terms = h.to_a.inject([:and]) do |anded,pair|
            anded << ([op] << sexpr(pair.first) << sexpr(pair.last))
          end
          _factor_predicate terms
        end
      end

      def eq(left, right = nil)
        return comp(:eq, left) if left.is_a?(Hash) and right.nil?
        _factor_predicate([:eq, sexpr(left), sexpr(right)])
      end

      def neq(left, right = nil)
        return comp(:neq, left) if left.is_a?(Hash) and right.nil?
        _factor_predicate([:neq, sexpr(left), sexpr(right)])
      end

      def lt(left, right = nil)
        return comp(:lt, left) if left.is_a?(Hash) and right.nil?
        _factor_predicate([:lt, sexpr(left), sexpr(right)])
      end

      def lte(left, right = nil)
        return comp(:lte, left) if left.is_a?(Hash) and right.nil?
        _factor_predicate([:lte, sexpr(left), sexpr(right)])
      end

      def gt(left, right = nil)
        return comp(:gt, left) if left.is_a?(Hash) and right.nil?
        _factor_predicate([:gt, sexpr(left), sexpr(right)])
      end

      def gte(left, right = nil)
        return comp(:gte, left) if left.is_a?(Hash) and right.nil?
        _factor_predicate([:gte, sexpr(left), sexpr(right)])
      end

      def between(middle, lower_bound, upper_bound)
        _factor_predicate [:and, [:gte, sexpr(middle), sexpr(lower_bound)],
                                 [:lte, sexpr(middle), sexpr(upper_bound)]]
      end

      def literal(literal)
        _factor_predicate([:literal, literal])
      end

      def native(proc)
        _factor_predicate([:native, proc])
      end

      def sexpr(expr)
        case expr
        when Expr       then expr
        when Predicate  then expr.expr
        when TrueClass  then Grammar.sexpr([:tautology, true])
        when FalseClass then Grammar.sexpr([:contradiction, false])
        when Symbol     then Grammar.sexpr([:var_ref, expr])
        when Proc       then Grammar.sexpr([:native, expr])
        when Array      then Grammar.sexpr(expr)
        else
          Grammar.sexpr([:literal, expr])
        end
      end

      def _factor_predicate(arg)
        sexpr(arg)
      end

      extend(self)
    end # module Factory
  end # class Predicate
end # module Alf
