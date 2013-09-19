module Alf
  class Optimizer
    class Restrict < Algebra::Rewriter
      include Lang::Functional

    ### overridings

      def call(restrict, search = nil)
        apply(restrict.operand, restrict.predicate)
      rescue NotSupportedError
        restrict
      end

      def restrict(operand, predicate)
        check_constant(operand, predicate){ super }
      end

      def apply(operand, predicate)
        check_constant(operand, predicate){ super }
      end

    # leaf Operand, recursion end :-)

      def on_leaf_operand(expr, predicate)
        restrict(expr, predicate)
      end
      alias :on_missing :on_leaf_operand

    ### pass through, unoptimizable, binary optimizable

      def on_pass_through(expr, predicate)
        expr.with_operands(*expr.operands.map{|op| apply(op, predicate)})
      end
      alias :on_clip        :on_pass_through
      alias :on_compact     :on_pass_through
      alias :on_sort        :on_pass_through
      alias :on_type_safe  :on_pass_through
      alias :on_project     :on_pass_through
      alias :on_intersect   :on_pass_through
      alias :on_minus       :on_pass_through
      alias :on_union       :on_pass_through

      def on_unoptimizable(expr, predicate)
        restrict(expr, predicate)
      end
      alias :on_generator     :on_unoptimizable
      alias :on_infer_heading :on_unoptimizable
      alias :on_page          :on_unoptimizable
      alias :on_frame         :on_unoptimizable

      def on_binary_optimizable(expr, predicate)
        binary_split(expr, predicate)
      end
      alias :on_join         :on_binary_optimizable
      alias :on_matching     :on_binary_optimizable
      alias :on_not_matching :on_binary_optimizable

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

      def on_quota(expr, predicate)
        unary_split(expr, predicate, expr.summarization.to_attr_list)
      end

      def on_rank(expr, predicate)
        unary_split(expr, predicate, AttrList[expr.as])
      end

      def on_rename(expr, predicate)
        begin
          predicate = predicate.rename(expr.renaming.invert)
        rescue NotSupportedError
          return restrict(expr, predicate)
        end
        on_pass_through(expr, predicate)
      end

      def on_restrict(expr, predicate)
        if predicate.native? or expr.predicate.native?
          restrict(expr, predicate)
        else
          apply(expr.operand, predicate & expr.predicate)
        end
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

    ### Splitting rules
    private

      def check_constant(operand, predicate)
        if predicate.tautology?
          operand
        elsif predicate.contradiction?
          Relation::DUM
        else
          yield
        end
      end

      def unary_split(expr, predicate, attr_list)
        top, down = predicate.and_split(attr_list)
        restrict(expr.with_operand(apply(expr.operand, down)), top)
      end

      def binary_split(expr, predicate)
        left_attrs, right_attrs = expr.operands.map{|op| op.heading.to_attr_list }
        left_only,  right_only  = left_attrs - right_attrs, right_attrs - left_attrs

        # left_top is the push-stopper due to right_only attributes
        # right_top is the push-stopper due to left_only attributes
        left_top,   left_pred   = predicate.and_split(right_only)
        right_top,  right_pred  = predicate.and_split(left_only)

        # left_rest is tautology if left_top is already fully covered by right_pred
        left_rest,  _ = left_top.and_split(left_only)
        # right_rest is a tautology if right_top is already fully covered by left_pred
        right_rest, _ = right_top.and_split(right_only)

        # basic join with restricted operands
        join = expr.with_operands(
          apply(expr.left, left_pred),
          apply(expr.right, right_pred))

        if left_top.tautology? || right_top.tautology?
          # everything is already covered by one restriction pushed
          join
        elsif left_rest.tautology? && right_rest.tautology?
          # everything is already covered by the conjunctions of pushed restrictions
          join
        else
          restrict(join, left_rest & right_rest)
        end
      end

    end # class Restrict
  end # class Optimizer
end # module Alf