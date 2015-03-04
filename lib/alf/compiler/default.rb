module Alf
  class Compiler
    class Default < Compiler

      def supports_reuse?
        true
      end

      def reuse(plan, cog)
        cog
      end

      ### non relational

      def on_autonum(plan, expr, compiled)
        factor(Engine::Autonum, expr, compiled, expr.as)
      end

      def on_clip(plan, expr, compiled)
        factor(Engine::Clip, expr, compiled, expr.attributes, expr.allbut)
      end

      def on_coerce(plan, expr, compiled)
        factor(Engine::Coerce, expr, compiled, expr.coercions)
      end

      def on_compact(plan, expr, compiled)
        factor(Engine::Compact, expr, compiled)
      end

      def on_defaults(plan, expr, compiled)
        compiled = plan.recompile(compiled){|p|
          p.clip(expr.operand, expr.defaults.to_attr_list)
        } if expr.strict
        factor(Engine::Defaults, expr, compiled, expr.defaults)
      end

      def on_generator(plan, expr)
        factor(Engine::Generator, expr, expr.as, 1, 1, expr.size)
      end

      def on_sort(plan, expr, compiled)
        return compiled if compiled.orderedby?(expr.ordering)
        factor(Engine::Sort, expr, compiled, expr.ordering)
      end

      ### relational

      def on_extend(plan, expr, compiled)
        factor(Engine::SetAttr, expr, compiled, expr.ext)
      end

      def on_frame(plan, expr, compiled)
        compiled = plan.recompile(compiled){|p|
          ordering = expr.total_ordering rescue expr.ordering
          p.sort(expr.operand, ordering)
        }
        factor(Engine::Take, expr, compiled, expr.offset, expr.limit)
      end

      def on_group(plan, expr, compiled)
        factor(Engine::Group::Hash, expr, compiled, expr.attributes, expr.as, expr.allbut)
      end

      def on_hierarchize(plan, expr, compiled)
        factor(Engine::Hierarchize, expr, compiled, expr.id, expr.parent, expr.as)
      end

      def on_image(plan, expr, left, right)
        factor(Engine::Image::Hash, expr, left, right, expr.as)
      end

      def on_intersect(plan, expr, left, right)
        factor(Engine::Join::Hash, expr, left, right)
      end

      def on_join(plan, expr, left, right)
        factor(Engine::Join::Hash, expr, left, right)
      end

      def on_matching(plan, expr, left, right)
        factor(Engine::Semi::Hash, expr, left, right, true)
      end

      def on_minus(plan, expr, left, right)
        factor(Engine::Semi::Hash, expr, left, right, false)
      end

      def on_not_matching(plan, expr, left, right)
        factor(Engine::Semi::Hash, expr, left, right, false)
      end

      def on_page(plan, expr, compiled)
        index, size = expr.page_index, expr.page_size
        compiled = plan.recompile(compiled){|p|
          ordering = expr.total_ordering rescue expr.ordering
          ordering = ordering.reverse if index < 0
          p.sort(expr.operand, ordering)
        }
        factor(Engine::Take, expr, compiled, (index.abs - 1) * size, size)
      end

      def on_project(plan, expr, compiled)
        preserving = expr.key_preserving? rescue false
        compiled = plan.recompile(compiled){|p|
          p.clip(expr.operand, expr.attributes, allbut: expr.allbut)
        }
        compiled = factor(Engine::Compact, expr, compiled) unless preserving
        compiled
      end

      def on_quota(plan, expr, compiled)
        compiled = plan.recompile(compiled){|p|
          p.sort(expr.operand, expr.by.to_ordering + expr.order)
        }
        factor(Engine::Quota::Cesure, expr, compiled, expr.by, expr.summarization)
      end

      def on_rank(plan, expr, compiled)
        compiled = plan.recompile(compiled){|p|
          p.sort(expr.operand, expr.order)
        }
        factor(Engine::Rank::Cesure, expr, compiled, expr.order, expr.as)
      end

      def on_rename(plan, expr, compiled)
        factor(Engine::Rename, expr, compiled, expr.renaming)
      end

      def on_restrict(plan, expr, compiled)
        factor(Engine::Filter, expr, compiled, expr.predicate)
      end

      def on_summarize(plan, expr, compiled)
        if expr.allbut
          factor(Engine::Summarize::Hash, expr, compiled, expr.by, expr.summarization, expr.allbut)
        else
          compiled = plan.recompile(compiled){|p|
            p.sort(expr.operand, expr.by.to_ordering)
          }
          factor(Engine::Summarize::Cesure, expr, compiled, expr.by, expr.summarization, expr.allbut)
        end
      end

      def on_ungroup(plan, expr, compiled)
        factor(Engine::Ungroup, expr, compiled, expr.attribute)
      end

      def on_union(plan, expr, left, right)
        compiled = factor(Engine::Concat, expr, [left, right])
        compiled = factor(Engine::Compact, expr, compiled)
        #
        compiled
      end

      def on_unwrap(plan, expr, compiled)
        factor(Engine::Unwrap, expr, compiled, expr.attribute)
      end

      def on_wrap(plan, expr, compiled)
        factor(Engine::Wrap, expr, compiled, expr.attributes, expr.as, expr.allbut)
      end

    private

      def factor(clazz, expr, *args)
        clazz.new(*args, expr, self)
      end

    end # class Default
  end # class Compiler
end # module Alf
