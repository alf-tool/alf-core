module Alf
  module Update
    class Deleter

      def compile(expr, predicate = TuplePredicate.coerce(true))
        name = Tools.ruby_case(Tools.class_name(expr.class))
        meth = :"on_#{name}"
        send(meth, expr, predicate)
      end

      ### VarRef, recursion end :-)

      def on_var_ref(expr, predicate)
        raise NotImplementedError
      end

      ### non relational

      def on_autonum(expr, predicate)
        raise NotSupportedError
      end

      def on_clip(expr, predicate)
        raise NotSupportedError
      end

      def on_coerce(expr, predicate)
        raise NotSupportedError
      end

      def on_compact(expr, predicate)
        raise NotSupportedError
      end

      def on_defaults(expr, predicate)
        raise NotSupportedError
      end

      def on_generator(expr, predicate)
        raise NotSupportedError
      end

      def on_sort(expr, predicate)
        raise NotSupportedError
      end

      ### relational

      def on_extend(expr, predicate)
        raise NotSupportedError
      end

      def on_group(expr, predicate)
        raise NotSupportedError
      end

      def on_infer_heading(expr, predicate)
        raise NotSupportedError
      end

      def on_intersect(expr, predicate)
        raise NotSupportedError
      end

      def on_join(expr, predicate)
        raise NotSupportedError
      end

      def on_matching(expr, predicate)
        raise NotSupportedError
      end

      def on_minus(expr, predicate)
        raise NotSupportedError
      end

      def on_not_matching(expr, predicate)
        raise NotSupportedError
      end

      def on_project(expr, predicate)
        raise NotSupportedError
      end

      def on_quota(expr, predicate)
        raise NotSupportedError
      end

      def on_rank(expr, predicate)
        raise NotSupportedError
      end

      def on_rename(expr, predicate)
        raise NotSupportedError
      end

      def on_restrict(expr, predicate)
        raise NotSupportedError
      end

      def on_summarize(expr, predicate)
        raise NotSupportedError
      end

      def on_ungroup(expr, predicate)
        raise NotSupportedError
      end

      def on_union(expr, predicate)
        raise NotSupportedError
      end

      def on_unwrap(expr, predicate)
        raise NotSupportedError
      end

      def on_wrap(expr, predicate)
        raise NotSupportedError
      end

    end # class Deleter
  end # module Update
end # module Alf
