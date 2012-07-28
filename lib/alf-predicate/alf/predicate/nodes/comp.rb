module Alf
  class Predicate
    module Comp
      include Expr

      def priority
        50
      end

      def &(other)
        return super unless other.is_a?(Comp) && (operator==other.operator)
        comp(operator, values.merge(other.values){|k,v1,v2|
          return contradiction unless v1 == v2
          v1
        })
      end

      def !
        comp(OP_NEGATIONS[operator], values)
      end

      def to_raw_expr
        op, h = sexpr_body
        if h.size == 1
          sexpr [op, sexpr(h.keys.first), sexpr(h.values.first)]
        else
          sexpr h.inject([:and]){|expr, pair|
            expr << ([op] << sexpr(pair.first) << sexpr(pair.last))
          }
        end
      end

      def operator
        self[1]
      end

      def values
        self[2]
      end

      def free_variables
        @free_variables ||= to_raw_expr.free_variables
      end

      def and_split(attr_list)
        to_raw_expr.and_split(attr_list)
      end

    end
  end
end
