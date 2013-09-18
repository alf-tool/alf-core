module Alf
  module Engine
    class Compilable

      def initialize(cog)
        @cog = cog
        @parser = Lang::Lispy.new
      end
      attr_reader :cog
      attr_reader :parser

      def expr
        cog.expr
      end

      ### main

      def to_cog(expr)
        send(expr.class.rubycase_name, expr)
      end

      ### non relational

      def autonum(expr)
        Autonum.new(self.cog, expr.as, expr)
      end

      def clip(expr, t = expr)
        Clip.new(self.cog, expr.attributes, expr.allbut, t)
      end

      def coerce(expr)
        Coerce.new(self.cog, expr.coercions, expr)
      end

      def compact(expr)
        Compact.new(self.cog, expr)
      end

      def defaults(expr)
        compiled = Defaults.new(self.cog, expr.defaults, expr)
        if expr.strict
          clipping = parser.clip(expr, expr.defaults.to_attr_list)
          compiled = compiled.to_compilable.clip(clipping, expr)
        end
        compiled
      end

      def generator(expr)
        Generator.new(expr.as, 1, 1, expr.size, expr)
      end

      def sort(expr)
        return self.cog if self.cog.orderedby?(expr.ordering)
        Sort.new(self.cog, expr.ordering, expr)
      end

      def type_safe(expr)
        checker = TypeCheck.new(expr.heading, expr.strict)
        TypeSafe.new(self.cog, checker, expr)
      end

      def infer_heading(expr)
        InferHeading.new(self.cog, expr)
      end

      ### relational

      def extend(expr)
        SetAttr.new(self.cog, expr.ext, expr)
      end

      def frame(expr)
        ordering = expr.full_ordering rescue expr.ordering
        #
        compiled = sort(parser.sort(expr, ordering))
        compiled = Take.new(compiled, expr.offset, expr.limit, expr)
        #
        compiled
      end

      def group(expr)
        Group::Hash.new(self.cog, expr.attributes, expr.as, expr.allbut, expr)
      end

      def intersect(expr)
        Join::Hash.new(self.cog, expr.right.to_cog, expr)
      end

      def join(expr)
        Join::Hash.new(self.cog, expr.right.to_cog, expr)
      end

      def matching(expr)
        Semi::Hash.new(self.cog, expr.right.to_cog, true, expr)
      end

      def minus(expr)
        Semi::Hash.new(self.cog, expr.right.to_cog, false, expr)
      end

      def not_matching(expr)
        Semi::Hash.new(self.cog, expr.right.to_cog, false, expr)
      end

      def page(expr)
        index, size = expr.page_index, expr.page_size
        #
        ordering = expr.full_ordering rescue expr.ordering
        ordering = ordering.reverse if index < 0
        #
        compiled = sort(parser.sort(expr, ordering))
        compiled = Take.new(compiled, (index.abs - 1) * size, size, expr)
        #
        compiled
      end

      def project(expr)
        preserving = expr.key_preserving? rescue false
        #
        compiled = Clip.new(self.cog, expr.attributes, expr.allbut, expr)
        compiled = Compact.new(compiled, expr) unless preserving
        #
        compiled
      end

      def quota(expr)
        compiled = sort(parser.sort(expr, expr.by.to_ordering + expr.order))
        compiled = Quota::Cesure.new(compiled, expr.by, expr.summarization, expr)
        #
        compiled
      end

      def rank(expr)
        compiled = sort(parser.sort(expr, expr.order))
        compiled = Rank::Cesure.new(compiled, expr.order, expr.as, expr)
        #
        compiled
      end

      def rename(expr)
        Rename.new(self.cog, expr.renaming, expr)
      end

      def restrict(expr)
        Filter.new(self.cog, expr.predicate, expr)
      end

      def summarize(expr)
        clazz = expr.allbut ? Summarize::Hash : Summarize::Cesure
        #
        compiled = self.cog
        unless expr.allbut
          compiled = compiled.to_compilable.sort(parser.sort(expr, expr.by.to_ordering))
        end
        compiled = clazz.new(compiled, expr.by, expr.summarization, expr.allbut, expr)
        #
        compiled
      end

      def ungroup(expr)
        Ungroup.new(self.cog, expr.attribute, expr)
      end

      def union(expr)
        compiled = Concat.new([self.cog, expr.right.to_cog], expr)
        compiled = Compact.new(compiled, expr)
        #
        compiled
      end

      def unwrap(expr)
        Unwrap.new(self.cog, expr.attribute, expr)
      end

      def wrap(expr)
        Wrap.new(self.cog, expr.attributes, expr.as, expr.allbut, expr)
      end

    end # class Compilable
  end # module Engine
end # module Alf
