module Alf
  module Engine
    class Compiler < Algebra::Compiler

      def not_supported(expr)
        # sub-compilers (i.e. Alf::Sequel's one) cheat a bit by partly rewriting
        # expressions so that their operands are actually Cogs...
        expr.is_a?(Cog) ? expr : super
      end

      ### leaf

      def on_leaf_operand(expr)
        expr.to_cog
      end

      ### non relational

      def on_autonum(expr)
        Autonum.new(apply(expr.operand), expr.as, expr)
      end

      def on_clip(expr)
        Clip.new(apply(expr.operand), expr.attributes, expr.allbut, expr)
      end

      def on_coerce(expr)
        Coerce.new(apply(expr.operand), expr.coercions, expr)
      end

      def on_compact(expr)
        Compact.new(apply(expr.operand), expr)
      end

      def on_defaults(expr)
        op = Defaults.new(apply(expr.operand), expr.defaults, expr)
        op = Clip.new(op, expr.defaults.to_attr_list, false, expr) if expr.strict
        op
      end

      def on_generator(expr)
        Generator.new(expr.as, 1, 1, expr.size, expr)
      end

      def on_sort(expr)
        Sort.new(apply(expr.operand), expr.ordering, expr)
      end

      def on_type_safe(expr)
        checker = TypeCheck.new(expr.heading, expr.strict)
        TypeSafe.new(apply(expr.operand), checker, expr)
      end

      ### relational

      def on_extend(expr)
        SetAttr.new(apply(expr.operand), expr.ext, expr)
      end

      def on_frame(expr)
        offset, limit = expr.offset, expr.limit
        ordering = unsupported(expr.ordering){ expr.total_ordering }
        op = Sort.new(apply(expr.operand), ordering, expr)
        op = Take.new(op, offset, limit, expr)
      end

      def on_page(expr)
        index, size = expr.page_index, expr.page_size
        ordering = unsupported(expr.ordering){ expr.total_ordering }
        ordering = ordering.reverse if index < 0
        op = Sort.new(apply(expr.operand), ordering, expr)
        op = Take.new(op, (index.abs - 1) * size, size, expr)
      end

      def on_group(expr)
        Group::Hash.new(apply(expr.operand), expr.attributes, expr.as, expr.allbut, expr)
      end

      def on_infer_heading(expr)
        InferHeading.new(apply(expr.operand), expr)
      end

      def on_intersect(expr)
        Join::Hash.new(apply(expr.left), apply(expr.right), expr)
      end

      def on_join(expr)
        Join::Hash.new(apply(expr.left), apply(expr.right), expr)
      end

      def on_matching(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), true, expr)
      end

      def on_minus(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), false, expr)
      end

      def on_not_matching(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), false, expr)
      end

      def on_project(expr)
        op = Clip.new(apply(expr.operand), expr.attributes, expr.allbut, expr)
        op = Compact.new(op, expr)
        op
      end

      def on_quota(expr)
        op = Sort.new(apply(expr.operand), expr.by.to_ordering + expr.order, expr)
        op = Quota::Cesure.new(op, expr.by, expr.summarization, expr)
        op
      end

      def on_rank(expr)
        op = Sort.new(apply(expr.operand), expr.order, expr)
        op = Rank::Cesure.new(op, expr.order.to_attr_list, expr.as, expr)
        op
      end

      def on_rename(expr)
        Rename.new(apply(expr.operand), expr.renaming, expr)
      end

      def on_restrict(expr)
        Filter.new(apply(expr.operand), expr.predicate, expr)
      end

      def on_summarize(expr)
        if expr.allbut
          Summarize::Hash.new(apply(expr.operand), expr.by, expr.summarization, expr.allbut, expr)
        else
          op = Sort.new(apply(expr.operand), expr.by.to_ordering, expr)
          op = Summarize::Cesure.new(op, expr.by, expr.summarization, expr.allbut, expr)
          op
        end
      end

      def on_ungroup(expr)
        Ungroup.new(apply(expr.operand), expr.attribute, expr)
      end

      def on_union(expr)
        op = Concat.new([apply(expr.left), apply(expr.right)], expr)
        op = Compact.new(op, expr)
        op
      end

      def on_unwrap(expr)
        Unwrap.new(apply(expr.operand), expr.attribute, expr)
      end

      def on_wrap(expr)
        Wrap.new(apply(expr.operand), expr.attributes, expr.as, expr.allbut, expr)
      end

    protected

      def unsupported(fallback, &bl)
        bl.call
      rescue NotSupportedError
        fallback
      end

    end # class Compiler
  end # module Engine
end # module Alf
