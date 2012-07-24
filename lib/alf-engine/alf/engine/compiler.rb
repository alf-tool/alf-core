module Alf
  module Engine
    class Compiler

      attr_reader :context

      def initialize(context)
        @context = context
      end

      def compile(expr)
        case expr
        when Operator::VarRef        then compile_reference(expr.name)
        when Operator            then compile_operator(expr)
        when String, Symbol      then compile_reference(expr)
        when Array, Relation     then expr
        when Reader, Relvar, Cog then expr
        when IO, StringIO        then Reader.coerce(expr)
        else
          raise ArgumentError, "Unexpected operand `#{expr.class}`"
        end
      end

      def compile_operator(expr)
        name = Tools.ruby_case(Tools.class_name(expr.class))
        meth = :"on_#{name}"
        send(meth, expr)
      end

      def compile_reference(expr)
        context.relvar(expr.to_sym)
      end

      ### non relational

      def on_autonum(expr)
        Autonum.new(compile(expr.operand), expr.as, context)
      end

      def on_clip(expr)
        Clip.new(compile(expr.operand), expr.attributes, expr.allbut, context)
      end

      def on_coerce(expr)
        Coerce.new(compile(expr.operand), expr.heading, context)
      end

      def on_compact(expr)
        Compact.new(compile(expr.operand), context)
      end

      def on_defaults(expr)
        op = Defaults.new(compile(expr.operand), expr.defaults, context)
        op = Clip.new(op, expr.defaults.to_attr_list, false, context) if expr.strict
        op
      end

      def on_generator(expr)
        Generator.new(expr.as, 1, 1, expr.size, context)
      end

      def on_sort(expr)
        Sort.new(compile(expr.operand), expr.ordering, context)
      end

      ### relational

      def on_extend(expr)
        SetAttr.new(compile(expr.operand), expr.ext, context)
      end

      def on_group(expr)
        Group::Hash.new(compile(expr.operand), expr.attributes, expr.as, expr.allbut, context)
      end

      def on_heading(expr)
        InferHeading.new(compile(expr.operand), context)
      end

      def on_intersect(expr)
        Join::Hash.new(compile(expr.left), compile(expr.right), context)
      end

      def on_join(expr)
        Join::Hash.new(compile(expr.left), compile(expr.right), context)
      end

      def on_matching(expr)
        Semi::Hash.new(compile(expr.left), compile(expr.right), true, context)
      end

      def on_minus(expr)
        Semi::Hash.new(compile(expr.left), compile(expr.right), false, context)
      end

      def on_not_matching(expr)
        Semi::Hash.new(compile(expr.left), compile(expr.right), false, context)
      end

      def on_project(expr)
        op = Clip.new(compile(expr.operand), expr.attributes, expr.allbut, context)
        op = Compact.new(op, context)
        op
      end

      def on_quota(expr)
        op = Sort.new(compile(expr.operand), expr.by.to_ordering + expr.order, context)
        op = Quota::Cesure.new(op, expr.by, expr.summarization, context)
        op
      end

      def on_rank(expr)
        op = Sort.new(compile(expr.operand), expr.order, context)
        op = Rank::Cesure.new(op, expr.order, expr.as, context)
        op
      end

      def on_rename(expr)
        Rename.new(compile(expr.operand), expr.renaming, context)
      end

      def on_restrict(expr)
        Filter.new(compile(expr.operand), expr.predicate, context)
      end

      def on_summarize(expr)
        if expr.allbut
          Summarize::Hash.new(compile(expr.operand), expr.by, expr.summarization, expr.allbut, context)
        else
          op = Sort.new(compile(expr.operand), expr.by.to_ordering, context)
          op = Summarize::Cesure.new(op, expr.by, expr.summarization, expr.allbut, context)
          op
        end
      end

      def on_ungroup(expr)
        Ungroup.new(compile(expr.operand), expr.attribute, context)
      end

      def on_union(expr)
        op = Concat.new([compile(expr.left), compile(expr.right)], context)
        op = Compact.new(op, context)
        op
      end

      def on_unwrap(expr)
        Unwrap.new(compile(expr.operand), expr.attribute, context)
      end

      def on_wrap(expr)
        Wrap.new(compile(expr.operand), expr.attributes, expr.as, false, context)
      end

    end # class Compiler
  end # module Engine
end # module Alf
