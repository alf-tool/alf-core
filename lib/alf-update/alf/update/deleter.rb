module Alf
  module Update
    class Deleter < Algebra::Compiler

      ### overridings

      def not_supported(expr, *args)
        raise NotSupportedError, "Unable to delete through `#{expr}`"
      end

      ### Reusable rules

      def apply_and_split(expr, predicate, list)
        top, down = predicate.and_split(list)
        if top.tautology?
          apply(expr.operand, predicate)
        else
          raise NotSupportedError
        end
      end

      def on_unary_delegate(expr, predicate)
        apply(expr.operand, predicate)
      end

      ### leaf Operand, recursion end :-)

      def on_leaf_operand(expr, predicate)
        expr.to_relvar.delete(predicate)
      end

      ### non relational

      def on_autonum(expr, predicate)
        apply_and_split(expr, predicate, AttrList[expr.as])
      end

      alias :on_clip :on_unary_delegate

      alias :on_coerce  :not_supported
      alias :on_compact :not_supported

      def on_defaults(expr, predicate)
        apply_and_split(expr, predicate, expr.defaults.to_attr_list)
      end

      alias :on_generator :not_supported

      alias :on_sort :on_unary_delegate

      ### relational

      def on_extend(expr, predicate)
        apply_and_split(expr, predicate, expr.ext.to_attr_list)
      end

      def on_group(expr, predicate)
        apply_and_split(expr, predicate, AttrList[expr.as])
      end

      alias :on_infer_heading :not_supported

      def on_intersect(expr, predicate)
        apply(expr.left, predicate)
        apply(expr.right, predicate)
      end

      alias :on_join      :not_supported
      alias :on_matching  :not_supported
      alias :on_minus     :not_supported
      alias :not_matching :not_supported

      alias :on_project :on_unary_delegate

      alias :on_quota :not_supported

      def on_rank(expr, predicate)
        apply_and_split(expr, predicate, AttrList[expr.as])
      end

      def on_rename(expr, predicate)
        apply_and_split(expr, predicate, expr.renaming.invert.to_attr_list)
      end

      def on_restrict(expr, predicate)
        apply(expr.operand, expr.predicate & predicate)
      end

      alias :on_summarize :not_supported
      alias :on_ungroup   :not_supported
      alias :on_union     :not_supported
      alias :on_unwrap    :not_supported

      def on_wrap(expr, predicate)
        apply_and_split(expr, predicate, AttrList[expr.as])
      end

    end # class Deleter
  end # module Update
end # module Alf
