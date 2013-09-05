module Alf
  module Engine
    class Compilable
      module Methods

        ### non relational

        def generator(expr)
          Generator.new(expr.as, 1, 1, expr.size, expr)
        end

        def sort(expr)
          Sort.new(self, expr.ordering, expr)
        end

        def type_safe(expr)
          checker = TypeCheck.new(expr.heading, expr.strict)
          TypeSafe.new(self, checker, expr)
        end

        ### relational

        def extend(expr)
          SetAttr.new(self, expr.ext, expr)
        end

        def page(expr)
          index, size = expr.page_index, expr.page_size
          ordering = unsupported(expr.ordering){ expr.full_ordering }
          ordering = ordering.reverse if index < 0
          op = Sort.new(self, ordering, expr)
          op = Take.new(op, (index.abs - 1) * size, size, expr)
        end

        def group(expr)
          Group::Hash.new(self, expr.attributes, expr.as, expr.allbut, expr)
        end

        def infer_heading(expr)
          InferHeading.new(self, expr)
        end

        def intersect(right, expr)
          Join::Hash.new(self, right, expr)
        end

        def join(right, expr)
          Join::Hash.new(self, right, expr)
        end

        def matching(right, expr)
          Semi::Hash.new(self, right, true, expr)
        end

        def minus(right, expr)
          Semi::Hash.new(self, right, false, expr)
        end

        def not_matching(right, expr)
          Semi::Hash.new(self, right, false, expr)
        end

        def project(expr)
          op = Clip.new(self, expr.attributes, expr.allbut, expr)
          op = Compact.new(op, expr)
          op
        end

        def quota(expr)
          op = Sort.new(self, expr.by.to_ordering + expr.order, expr)
          op = Quota::Cesure.new(op, expr.by, expr.summarization, expr)
          op
        end

        def rank(expr)
          op = Sort.new(self, expr.order, expr)
          op = Rank::Cesure.new(op, expr.order, expr.as, expr)
          op
        end

        def rename(expr)
          Rename.new(self, expr.renaming, expr)
        end

        def restrict(expr)
          Filter.new(self, expr.predicate, expr)
        end

        def summarize(expr)
          if expr.allbut
            Summarize::Hash.new(self, expr.by, expr.summarization, expr.allbut, expr)
          else
            op = Sort.new(self, expr.by.to_ordering, expr)
            op = Summarize::Cesure.new(op, expr.by, expr.summarization, expr.allbut, expr)
            op
          end
        end

        def ungroup(expr)
          Ungroup.new(self, expr.attribute, expr)
        end

        def union(right, expr)
          op = Concat.new([self, right], expr)
          op = Compact.new(op, expr)
          op
        end

        def unwrap(expr)
          Unwrap.new(self, expr.attribute, expr)
        end

        def wrap(expr)
          Wrap.new(self, expr.attributes, expr.as, expr.allbut, expr)
        end

      end # module Methods
    end # module Compilable
  end # module Engine
end # module Alf
