module Alf
  module Update
    class Inserter < Lang::Compiler
      include Lang::Functional

      ### VarRef, recursion end :-)

      def on_var_ref(expr, inserted)
        expr.context.insert(expr.name, inserted)
      end

      ### non relational

      def unsupported(*args)
        raise NotSupportedError
      end
      alias :on_coerce    :unsupported
      alias :on_generator :unsupported

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

      alias :on_infer_heading :unsupported

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

      alias :on_quota :unsupported

      def on_rank(expr, inserted)
        apply(expr.operand, allbut(inserted, [expr.as]))
      end

      def on_rename(expr, inserted)
        apply(expr.operand, rename(inserted, expr.renaming.inverse))
      end

      def on_restrict(expr, inserted)
        # TODO: check that restrict(inserted, expr.predicate)==inserted
        apply(expr.operand, inserted)
      end

      alias :on_summarize :unsupported
      alias :on_ungroup :unsupported

      def on_union(expr, inserted)
        apply(expr.left,  inserted)
        apply(expr.right, inserted)
      end

      alias :on_unwrap :unsupported

      def on_wrap(expr, inserted)
        apply(expr.operand, unwrap(inserted, expr.as))
      end

    end # class Inserter
  end # module Update
end # module Alf
