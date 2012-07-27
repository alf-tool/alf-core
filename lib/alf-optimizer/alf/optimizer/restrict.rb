module Alf
  class Optimizer
    class Restrict < Processor

      def check_constant(operand, predicate)
        if predicate.tautology?
          operand
        elsif predicate.contradiction?
          Relation::DUM
        else
          yield
        end
      end

      def call(restrict)
        apply(restrict.operand, restrict.predicate)
      end

      def restrict(operand, predicate)
        check_constant(operand, predicate){ super }
      end

      def apply(operand, predicate)
        check_constant(operand, predicate){ super }
      end

      def unary_split(expr, predicate, attr_list)
        top, down = predicate.and_split(attr_list)
        restrict(expr.with_operand(apply(expr.operand, down)), top)
      end

      ### catch all, pass-through, unoptimizable

      def on_missing(expr, predicate)
        restrict(expr, predicate)
      end

      def on_pass_through(expr, predicate)
        expr.with_operands(*expr.operands.map{|op| apply(op, predicate)})
      end
      alias :on_clip      :on_pass_through
      alias :on_compact   :on_pass_through
      alias :on_sort      :on_pass_through
      alias :on_project   :on_pass_through
      alias :on_intersect :on_pass_through
      alias :on_minus     :on_pass_through
      alias :on_union     :on_pass_through

      def on_unoptimizable(expr, predicate)
        restrict(expr, predicate)
      end
      alias :on_generator     :on_unoptimizable
      alias :on_infer_heading :on_unoptimizable

      ### non relational

      def on_autonum(expr, predicate)
        unary_split(expr, predicate, AttrList[expr.as])
      end

      def on_coerce(expr, predicate)
        unary_split(expr, predicate, expr.coercions.to_attr_list)
      end

      def on_defaults(expr, predicate)
        unary_split(expr, predicate, expr.defaults.to_attr_list)
      end

      ### relational

      def on_extend(expr, predicate)
        unary_split(expr, predicate, expr.ext.to_attr_list)
      end

      def on_group(expr, predicate)
        unary_split(expr, predicate, AttrList[expr.as])
      end

      def on_join(expr, predicate)
        # TODO: we could be MUCH smarter here
        restrict(expr, predicate)
      end

      def on_matching(expr, predicate)
        # TODO: we could be smarter here
        expr.with_left(apply(expr.left, predicate))
      end

      def on_not_matching(expr, predicate)
        # TODO: we could be smarter here
        expr.with_left(apply(expr.left, predicate))
      end

      def on_quota(expr, predicate)
        unary_split(expr, predicate, expr.summarization.to_attr_list)
      end

      def on_rank(expr, predicate)
        unary_split(expr, predicate, AttrList[expr.as])
      end

      def on_rename(expr, predicate)
        # TODO:
        restrict(expr, predicate)
      end

      def on_restrict(expr, predicate)
        apply(expr.operand, predicate & expr.predicate)
      end

      def on_summarize(expr, predicate)
        unary_split(expr, predicate, expr.summarization.to_attr_list)
      end

      def on_ungroup(expr, predicate)
        # TODO:
        restrict(expr, predicate)
      end

      def on_unwrap(expr, predicate)
        # TODO:
        restrict(expr, predicate)
      end

      def on_wrap(expr, predicate)
        unary_split(expr, predicate, AttrList[expr.as])
      end

    end # class Restrict
  end # class Optimizer
end # module Alf