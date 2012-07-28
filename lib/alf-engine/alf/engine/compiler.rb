module Alf
  module Engine
    class Compiler < Lang::Compiler

      attr_reader :context

      def initialize(context)
        @context = context
      end

      ### to be cleaned

      def on_outside(expr)
        case expr
        when String, Symbol      then context.relvar(expr.to_sym)
        when Array, Relation     then expr
        when Reader, Relvar, Cog then expr
        when IO, StringIO        then Reader.coerce(expr)
        else
          super
        end
      end

      ### VarRef, end of recursion :-)

      def on_var_ref(expr)
        context.relvar(expr.name.to_sym)
      end

      ### non relational

      def on_autonum(expr)
        Autonum.new(apply(expr.operand), expr.as, context)
      end

      def on_clip(expr)
        Clip.new(apply(expr.operand), expr.attributes, expr.allbut, context)
      end

      def on_coerce(expr)
        Coerce.new(apply(expr.operand), expr.coercions, context)
      end

      def on_compact(expr)
        Compact.new(apply(expr.operand), context)
      end

      def on_defaults(expr)
        op = Defaults.new(apply(expr.operand), expr.defaults, context)
        op = Clip.new(op, expr.defaults.to_attr_list, false, context) if expr.strict
        op
      end

      def on_generator(expr)
        Generator.new(expr.as, 1, 1, expr.size, context)
      end

      def on_sort(expr)
        Sort.new(apply(expr.operand), expr.ordering, context)
      end

      ### relational

      def on_extend(expr)
        SetAttr.new(apply(expr.operand), expr.ext, context)
      end

      def on_group(expr)
        Group::Hash.new(apply(expr.operand), expr.attributes, expr.as, expr.allbut, context)
      end

      def on_infer_heading(expr)
        InferHeading.new(apply(expr.operand), context)
      end

      def on_intersect(expr)
        Join::Hash.new(apply(expr.left), apply(expr.right), context)
      end

      def on_join(expr)
        Join::Hash.new(apply(expr.left), apply(expr.right), context)
      end

      def on_matching(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), true, context)
      end

      def on_minus(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), false, context)
      end

      def on_not_matching(expr)
        Semi::Hash.new(apply(expr.left), apply(expr.right), false, context)
      end

      def on_project(expr)
        op = Clip.new(apply(expr.operand), expr.attributes, expr.allbut, context)
        op = Compact.new(op, context)
        op
      end

      def on_quota(expr)
        op = Sort.new(apply(expr.operand), expr.by.to_ordering + expr.order, context)
        op = Quota::Cesure.new(op, expr.by, expr.summarization, context)
        op
      end

      def on_rank(expr)
        op = Sort.new(apply(expr.operand), expr.order, context)
        op = Rank::Cesure.new(op, expr.order, expr.as, context)
        op
      end

      def on_rename(expr)
        Rename.new(apply(expr.operand), expr.renaming, context)
      end

      def on_restrict(expr)
        Filter.new(apply(expr.operand), expr.predicate, context)
      end

      def on_summarize(expr)
        if expr.allbut
          Summarize::Hash.new(apply(expr.operand), expr.by, expr.summarization, expr.allbut, context)
        else
          op = Sort.new(apply(expr.operand), expr.by.to_ordering, context)
          op = Summarize::Cesure.new(op, expr.by, expr.summarization, expr.allbut, context)
          op
        end
      end

      def on_ungroup(expr)
        Ungroup.new(apply(expr.operand), expr.attribute, context)
      end

      def on_union(expr)
        op = Concat.new([apply(expr.left), apply(expr.right)], context)
        op = Compact.new(op, context)
        op
      end

      def on_unwrap(expr)
        Unwrap.new(apply(expr.operand), expr.attribute, context)
      end

      def on_wrap(expr)
        Wrap.new(apply(expr.operand), expr.attributes, expr.as, expr.allbut, context)
      end

    end # class Compiler
  end # module Engine
end # module Alf
