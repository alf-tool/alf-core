module Alf
  class Compiler
    class Default < Compiler

      ###

      def on_leaf_operand(expr)
        expr.to_cog
      end

      ### non relational

      def on_autonum(expr, compiled)
        factor(Engine::Autonum, expr, compiled, expr.as)
      end

      def on_clip(expr, compiled)
        factor(Engine::Clip, expr, compiled, expr.attributes, expr.allbut)
      end

      def on_coerce(expr, compiled)
        factor(Engine::Coerce, expr, compiled, expr.coercions)
      end

      def on_compact(expr, compiled)
        factor(Engine::Compact, expr, compiled)
      end

      def on_defaults(expr, compiled)
        compiled = factor(Engine::Defaults, expr, compiled, expr.defaults)
        if expr.strict
          clipping = parser.clip(expr, expr.defaults.to_attr_list)
          compiled = self._call(clipping, [compiled])
        end
        compiled
      end

      def on_generator(expr)
        factor(Engine::Generator, expr, expr.as, 1, 1, expr.size)
      end

      def on_sort(expr, compiled)
        return compiled if compiled.orderedby?(expr.ordering)
        factor(Engine::Sort, expr, compiled, expr.ordering)
      end

      def on_type_safe(expr, compiled)
        checker = TypeCheck.new(expr.heading, expr.strict)
        factor(Engine::TypeSafe, expr, compiled, checker)
      end

      def on_infer_heading(expr, compiled)
        factor(Engine::InferHeading, expr, compiled)
      end

      ### relational

      def on_extend(expr, compiled)
        factor(Engine::SetAttr, expr, compiled, expr.ext)
      end

      def on_frame(expr, compiled)
        ordering = expr.total_ordering rescue expr.ordering
        #
        compiled = self._call(parser.sort(expr, ordering), [compiled])
        compiled = factor(Engine::Take, expr, compiled, expr.offset, expr.limit)
        #
        compiled
      end

      def on_group(expr, compiled)
        factor(Engine::Group::Hash, expr, compiled, expr.attributes, expr.as, expr.allbut)
      end

      def on_hierarchize(expr, compiled)
        factor(Engine::Hierarchize, expr, compiled, expr.id, expr.parent, expr.as)
      end

      def on_intersect(expr, left, right)
        factor(Engine::Join::Hash, expr, left, right)
      end

      def on_join(expr, left, right)
        factor(Engine::Join::Hash, expr, left, right)
      end

      def on_matching(expr, left, right)
        factor(Engine::Semi::Hash, expr, left, right, true)
      end

      def on_minus(expr, left, right)
        factor(Engine::Semi::Hash, expr, left, right, false)
      end

      def on_not_matching(expr, left, right)
        factor(Engine::Semi::Hash, expr, left, right, false)
      end

      def on_page(expr, compiled)
        index, size = expr.page_index, expr.page_size
        #
        ordering = expr.total_ordering rescue expr.ordering
        ordering = ordering.reverse if index < 0
        #
        compiled = self._call(parser.sort(expr, ordering), [compiled])
        compiled = factor(Engine::Take, expr, compiled, (index.abs - 1) * size, size)
        #
        compiled
      end

      def on_project(expr, compiled)
        preserving = expr.key_preserving? rescue false
        #
        compiled = factor(Engine::Clip, expr, compiled, expr.attributes, expr.allbut)
        compiled = factor(Engine::Compact, expr, compiled) unless preserving
        #
        compiled
      end

      def on_quota(expr, compiled)
        compiled = self._call(parser.sort(expr, expr.by.to_ordering + expr.order), [compiled])
        compiled = factor(Engine::Quota::Cesure, expr, compiled, expr.by, expr.summarization)
        #
        compiled
      end

      def on_rank(expr, compiled)
        compiled = self._call(parser.sort(expr, expr.order), [compiled])
        compiled = factor(Engine::Rank::Cesure, expr, compiled, expr.order, expr.as)
        #
        compiled
      end

      def on_rename(expr, compiled)
        factor(Engine::Rename, expr, compiled, expr.renaming)
      end

      def on_restrict(expr, compiled)
        factor(Engine::Filter, expr, compiled, expr.predicate)
      end

      def on_summarize(expr, compiled)
        if expr.allbut
          factor(Engine::Summarize::Hash, expr, compiled, expr.by, expr.summarization, expr.allbut)
        else
          compiled = self._call(parser.sort(expr, expr.by.to_ordering), [compiled])
          factor(Engine::Summarize::Cesure, expr, compiled, expr.by, expr.summarization, expr.allbut)
        end
      end

      def on_ungroup(expr, compiled)
        factor(Engine::Ungroup, expr, compiled, expr.attribute)
      end

      def on_union(expr, left, right)
        compiled = factor(Engine::Concat, expr, [left, right])
        compiled = factor(Engine::Compact, expr, compiled)
        #
        compiled
      end

      def on_unwrap(expr, compiled)
        factor(Engine::Unwrap, expr, compiled, expr.attribute)
      end

      def on_wrap(expr, compiled)
        factor(Engine::Wrap, expr, compiled, expr.attributes, expr.as, expr.allbut)
      end

    private

      def factor(clazz, expr, *args)
        clazz.new(*args, expr, self)
      end

    end # class Default
  end # class Compiler
end # module Alf
