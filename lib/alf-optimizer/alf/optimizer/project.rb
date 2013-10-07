module Alf
  class Optimizer
    class Project < Optimizer::Base

    ### overridings

      def search_predicate
        Algebra::Project
      end

      def _call(project, search)
        apply(project.operand, project.attributes, project.allbut, search)
      end

    ### operator callbacks

      def on_unoptimizable(expr, attributes, allbut, search)
        project(search.call(expr), attributes, allbut: allbut)
      end
      alias :on_missing      :on_unoptimizable
      alias :on_leaf_operand :on_unoptimizable

      def on_project(expr, attributes, allbut, search)
        inside, outside = expr.attributes, attributes
        if expr.allbut != allbut
          attributes = allbut ? inside - outside : outside - inside
          allbut = false
        else
          attributes = allbut ? inside | outside : inside & outside
        end
        apply(expr.operand, attributes, allbut, search)
      end
      alias :on_clip :on_project

      def on_extend(expr, attributes, allbut, search)
        ext = expr.ext.project(attributes, allbut)
        if ext.empty?
          apply(expr.operand, attributes, allbut, search)
        else
          op = search.call(expr.operand)
          project(extend(op, ext), attributes, allbut: allbut)
        end
      end

    end # class Project
  end # class Optimizer
end # module Alf
