module Alf
  module Update
    class Inserter

      def compile(expr, inserted)
        name = Tools.ruby_case(Tools.class_name(expr.class))
        meth = :"on_#{name}"
        send(meth, expr, inserted)
      end

      ### VarRef, recursion end :-)

      def on_var_ref(expr, inserted)
        raise NotImplementedError
      end

      ### non relational

      def on_autonum(expr, inserted)
        compile(expr.operand, allbut(inserted, expr.as))
      end

      def on_clip(expr, inserted)
        defaults = expr.attributes.project_tuple(expr.defaults, expr.allbut)
        compile(expr.operand, extend(inserted, defaults))
      end

      def on_coerce(expr, inserted)
        raise NotSupportedError
      end

      def on_compact(expr, inserted)
        compile(expr.operand, inserted)
      end

      def on_defaults(expr, inserted)
        compile(expr.operand, defaults(inserted, expr.defaults))
      end

      def on_generator(expr, inserted)
        raise NotSupportedError
      end

      def on_sort(expr, inserted)
        compile(expr.operand, sort(inserted, expr.ordering))
      end

      ### relational

      def on_extend(expr, inserted)
        compile(expr.operand, allbut(inserted, expr.ext.to_attr_list))
      end

      def on_group(expr, inserted)
        compile(expr.operand, ungroup(inserted, expr.as))
      end

      def on_infer_heading(expr, inserted)
        raise NotSupportedError
      end

      def on_intersect(expr, inserted)
        compile(expr.left, inserted)
        compile(expr.right, inserted)
      end

      def on_join(expr, inserted)
        compile(expr.left,  inserted)
        compile(expr.right, inserted)
      end

      def on_matching(expr, inserted)
        # TODO: check that not_matching(inserted, expr.right) is empty
        compile(expr.left, inserted)
      end

      def on_minus(expr, inserted)
        # TODO: check that intersect(inserted, expr.right) is empty
        compile(expr.left, inserted)
      end

      def on_not_matching(expr, inserted)
        # TODO: check that matching(inserted, expr.right) is empty
        compile(expr.left, inserted)
      end

      def on_project(expr, inserted)
        defaults = expr.attributes.project_tuple(expr.defaults, expr.allbut)
        compile(expr.operand, extend(inserted, defaults))
      end

      def on_quota(expr, inserted)
        raise NotSupportedError
      end

      def on_rank(expr, inserted)
        compile(expr.operand, allbut(inserted, expr.as))
      end

      def on_rename(expr, inserted)
        compile(expr.operand, rename(inserted, expr.renaming.reverse))
      end

      def on_restrict(expr, inserted)
        # TODO: check that restrict(inserted, expr.predicate)==inserted
        compile(expr.operand, inserted)
      end

      def on_summarize(expr, inserted)
        raise NotSupportedError
      end

      def on_ungroup(expr, inserted)
        raise NotSupportedError
      end

      def on_union(expr, inserted)
        compile(expr.left,  inserted)
        compile(expr.right, inserted)
      end

      def on_unwrap(expr, inserted)
        raise NotSupportedError
      end

      def on_wrap(expr, inserted)
        compile(expr.operand, unwrap(inserted, expr.as))
      end

    end # class Inserter
  end # module Update
end # module Alf
