module Alf
  module Engine
    class Compilable

      def initialize(cog)
        @cog = cog
        @parser = Lang::Lispy.new
      end

      ### main

      def compile(expr)
        send(expr.class.rubycase_name, expr).to_cog
      end

      ### non relational

      def autonum(expr, traceability = expr)
        compiled = Autonum.new(@cog, expr.as, traceability)
        compiled.to_compilable
      end

      def clip(expr, traceability = expr)
        compiled = Clip.new(@cog, expr.attributes, expr.allbut, traceability)
        compiled.to_compilable
      end

      def coerce(expr, traceability = expr)
        compiled = Coerce.new(@cog, expr.coercions, traceability)
        compiled.to_compilable
      end

      def compact(expr, traceability = expr)
        compiled = Compact.new(@cog, traceability)
        compiled.to_compilable
      end

      def defaults(expr, traceability = expr)
        defaults = expr.defaults
        compiled = Defaults.new(@cog, defaults, traceability)
        if expr.strict
          clipping = @parser.clip(expr, defaults.to_attr_list)
          compiled = compiled.to_compilable.clip(clipping, traceability).to_cog
        end
        compiled.to_compilable
      end

      def generator(expr, traceability = expr)
        compiled = Generator.new(expr.as, 1, 1, expr.size, traceability)
        compiled.to_compilable
      end

      def sort(expr, traceability = expr)
        ordering = expr.ordering
        compiled = @cog
        unless @cog.orderedby?(ordering)
          compiled = Sort.new(compiled, ordering, traceability)
        end
        compiled.to_compilable
      end

      def type_safe(expr, traceability = expr)
        checker  = TypeCheck.new(expr.heading, expr.strict)
        compiled = TypeSafe.new(@cog, checker, traceability)
        compiled.to_compilable
      end

      ### relational

      def extend(expr, traceability = expr)
        compiled = SetAttr.new(@cog, expr.ext, traceability)
        compiled.to_compilable
      end

      def group(expr, traceability = expr)
        compiled = Group::Hash.new(@cog, expr.attributes, expr.as, expr.allbut, traceability)
        compiled.to_compilable
      end

      def infer_heading(expr, traceability = expr)
        compiled = InferHeading.new(@cog, traceability)
        compiled.to_compilable
      end

      def intersect(expr, traceability = expr)
        compiled = Join::Hash.new(@cog, expr.right.compile, traceability)
        compiled.to_compilable
      end

      def join(expr, traceability = expr)
        compiled = Join::Hash.new(@cog, expr.right.compile, traceability)
        compiled.to_compilable
      end

      def matching(expr, traceability = expr)
        compiled = Semi::Hash.new(@cog, expr.right.compile, true, traceability)
        compiled.to_compilable
      end

      def minus(expr, traceability = expr)
        compiled = Semi::Hash.new(@cog, expr.right.compile, false, traceability)
        compiled.to_compilable
      end

      def not_matching(expr, traceability = expr)
        compiled = Semi::Hash.new(@cog, expr.right.compile, false, traceability)
        compiled.to_compilable
      end

      def page(expr, traceability = expr)
        index, size = expr.page_index, expr.page_size
        ordering = expr.full_ordering rescue expr.ordering
        ordering = ordering.reverse if index < 0
        compiled = sort(@parser.sort(expr, ordering)).to_cog
        compiled = Take.new(compiled, (index.abs - 1) * size, size, traceability)
        compiled.to_compilable
      end

      def project(expr, traceability = expr)
        compiled   = Clip.new(@cog, expr.attributes, expr.allbut, traceability)
        preserving = expr.key_preserving? rescue false
        compiled   = Compact.new(compiled, traceability) unless preserving
        compiled.to_compilable
      end

      def quota(expr, traceability = expr)
        compiled = sort(@parser.sort(expr, expr.by.to_ordering + expr.order)).to_cog
        compiled = Quota::Cesure.new(compiled, expr.by, expr.summarization, traceability)
        compiled.to_compilable
      end

      def rank(expr, traceability = expr)
        compiled = sort(@parser.sort(expr, expr.order)).to_cog
        compiled = Rank::Cesure.new(compiled, expr.order, expr.as, traceability)
        compiled.to_compilable
      end

      def rename(expr, traceability = expr)
        compiled = Rename.new(@cog, expr.renaming, traceability)
        compiled.to_compilable
      end

      def restrict(expr, traceability = expr)
        compiled = Filter.new(@cog, expr.predicate, traceability)
        compiled.to_compilable
      end

      def summarize(expr, traceability = expr)
        if expr.allbut
          compiled = Summarize::Hash.new(@cog, expr.by, expr.summarization, expr.allbut, traceability)
        else
          compiled = sort(@parser.sort(expr, expr.by.to_ordering)).to_cog
          compiled = Summarize::Cesure.new(compiled, expr.by, expr.summarization, expr.allbut, traceability)
        end
        compiled.to_compilable
      end

      def ungroup(expr, traceability = expr)
        compiled = Ungroup.new(@cog, expr.attribute, traceability)
        compiled.to_compilable
      end

      def union(expr, traceability = expr)
        compiled = Concat.new([@cog, expr.right.compile], traceability)
        compiled = Compact.new(compiled, expr)
        compiled.to_compilable
      end

      def unwrap(expr, traceability = expr)
        compiled = Unwrap.new(@cog, expr.attribute, traceability)
        compiled.to_compilable
      end

      def wrap(expr, traceability = expr)
        compiled = Wrap.new(@cog, expr.attributes, expr.as, expr.allbut, traceability)
        compiled.to_compilable
      end

      ### traceability

      def expr
        to_cog.expr
      end

      ### to_xxx

      def to_cog
        @cog
      end

    end # class Compilable
  end # module Engine
end # module Alf
