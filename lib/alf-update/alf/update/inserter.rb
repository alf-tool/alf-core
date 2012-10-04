module Alf
  module Update
    class Inserter < Lang::Compiler
      include Lang::Functional

      ### overridings

      def call(expr, tuples)
        super(expr, Alf::Algebra::Operand.coerce(tuples))
      end

      def not_supported(expr, *args)
        raise NotSupportedError, "Unable to insert through `#{expr}`"
      end

      ### Operand::Leaf, recursion end :-)

      def on_leaf_operand(expr, inserted)
        expr.insert(inserted)
      end

      ### non relational

      alias :on_coerce    :not_supported
      alias :on_generator :not_supported

      def on_autonum(expr, inserted)
        apply(expr.operand, allbut(inserted, [expr.as]))
      end

      def on_clip(expr, inserted)
        defaults = expr.attributes.project_tuple(expr.defaults, expr.allbut)
        apply(expr.operand, extend(inserted, defaults))
      end

      def on_compact(expr, inserted)
        apply(expr.operand, inserted)
      end

      def on_defaults(expr, inserted)
        apply(expr.operand, defaults(inserted, expr.defaults))
      end

      def on_sort(expr, inserted)
        apply(expr.operand, sort(inserted, expr.ordering))
      end

      ### relational

      def on_extend(expr, inserted)
        apply(expr.operand, allbut(inserted, expr.ext.to_attr_list))
      end

      def on_group(expr, inserted)
        apply(expr.operand, ungroup(inserted, expr.as))
      end

      alias :on_infer_heading :not_supported

      def on_intersect(expr, inserted)
        apply(expr.left, inserted)
        apply(expr.right, inserted)
      end

      def on_join(expr, inserted)
        apply(expr.left,  project(inserted, expr.left.heading.to_attr_list))
        apply(expr.right, project(inserted, expr.right.heading.to_attr_list))
      end

      def on_matching(expr, inserted)
        # TODO: check that not_matching(inserted, expr.right) is empty
        apply(expr.left, inserted)
      end

      def on_minus(expr, inserted)
        # TODO: check that intersect(inserted, expr.right) is empty
        apply(expr.left, inserted)
      end

      def on_not_matching(expr, inserted)
        # TODO: check that matching(inserted, expr.right) is empty
        apply(expr.left, inserted)
      end

      def on_project(expr, inserted)
        defaults = expr.attributes.project_tuple(expr.defaults, expr.allbut)
        apply(expr.operand, extend(inserted, defaults))
      end

      alias :on_quota :not_supported

      def on_rank(expr, inserted)
        apply(expr.operand, allbut(inserted, [expr.as]))
      end

      def on_rename(expr, inserted)
        apply(expr.operand, rename(inserted, expr.renaming.invert))
      end

      def on_restrict(expr, inserted)
        # TODO: check that restrict(inserted, expr.predicate)==inserted
        apply(expr.operand, inserted)
      end

      alias :on_summarize :not_supported
      alias :on_ungroup :not_supported

      def on_union(expr, inserted)
        apply(expr.left,  inserted)
        apply(expr.right, inserted)
      end

      alias :on_unwrap :not_supported

      def on_wrap(expr, inserted)
        apply(expr.operand, unwrap(inserted, expr.as))
      end

    end # class Inserter
  end # module Update
end # module Alf
