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
        Autonum.new(apply(expr.operand), expr.as)
      end

      def on_clip(expr)
        Clip.new(apply(expr.operand), expr.attributes, expr.allbut)
      end

      def on_coerce(expr)
        Coerce.new(apply(expr.operand), expr.coercions)
      end

      def on_compact(expr)
        Compact.new(apply(expr.operand))
      end

      def on_defaults(expr)
        op = Defaults.new(apply(expr.operand), expr.defaults)
        op = Clip.new(op, expr.defaults.to_attr_list, false) if expr.strict
        op
      end

      def on_generator(expr)
        Generator.new(expr.as, 1, 1, expr.size)
      end

      def on_sort(expr)
        Sort.new(apply(expr.operand), expr.ordering)
      end

      def on_type_safe(expr)
        checker = TypeCheck.new(expr.heading, expr.strict)
        TypeSafe.new(apply(expr.operand), checker)
      end

      ### relational

      def on_extend(expr)
        SetAttr.new(apply(expr.operand), expr.ext)
      end

      def on_page(expr)
        op = Sort.new(apply(expr.operand), expr.full_ordering)
        Take.new(op, expr.offset, expr.page_size)
      rescue NotSupportedError
        op = Sort.new(apply(expr.operand), expr.ordering)
        Take.new(op, expr.offset, expr.page_size)
      end

      def on_group(expr)
        Group::Hash.new(apply(expr.operand), expr.attributes, expr.as, expr.allbut)
      end

      def on_infer_heading(expr)
        InferHeading.new(apply(expr.operand))
      end

      def on_intersect(expr)
        Join::Hash.new(apply(expr.left), apply(expr.right))
      end

      def on_join(expr)
        Join::Hash.new(apply(expr.left), apply(expr.right))
      end

      def on_matching(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), true)
      end

      def on_minus(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), false)
      end

      def on_not_matching(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), false)
      end

      def on_project(expr)
        op = Clip.new(apply(expr.operand), expr.attributes, expr.allbut)
        op = Compact.new(op)
        op
      end

      def on_quota(expr)
        op = Sort.new(apply(expr.operand), expr.by.to_ordering + expr.order)
        op = Quota::Cesure.new(op, expr.by, expr.summarization)
        op
      end

      def on_rank(expr)
        op = Sort.new(apply(expr.operand), expr.order)
        op = Rank::Cesure.new(op, expr.order, expr.as)
        op
      end

      def on_rename(expr)
        Rename.new(apply(expr.operand), expr.renaming)
      end

      def on_restrict(expr)
        Filter.new(apply(expr.operand), expr.predicate)
      end

      def on_summarize(expr)
        if expr.allbut
          Summarize::Hash.new(apply(expr.operand), expr.by, expr.summarization, expr.allbut)
        else
          op = Sort.new(apply(expr.operand), expr.by.to_ordering)
          op = Summarize::Cesure.new(op, expr.by, expr.summarization, expr.allbut)
          op
        end
      end

      def on_ungroup(expr)
        Ungroup.new(apply(expr.operand), expr.attribute)
      end

      def on_union(expr)
        op = Concat.new([apply(expr.left), apply(expr.right)])
        op = Compact.new(op)
        op
      end

      def on_unwrap(expr)
        Unwrap.new(apply(expr.operand), expr.attribute)
      end

      def on_wrap(expr)
        Wrap.new(apply(expr.operand), expr.attributes, expr.as, expr.allbut)
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
