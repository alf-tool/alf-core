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

      def apply(expr, attributes, allbut, search)
        check_stop(expr, attributes, allbut, search){ super }
      rescue NotSupportedError
        project(expr, attributes, allbut)
      end

      def check_stop(expr, attributes, allbut, search)
        return search.call(expr) if (allbut  && attributes.empty?)
        return search.call(expr) if (!allbut && attributes==expr.attr_list)
        yield
      rescue NotSupportedError
        yield
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

      def on_join(expr, attributes, allbut, search)
        commons = expr.left.attr_list & expr.right.attr_list

        # compute actual projection attributes on left and right
        proj_a  = allbut ? attributes - commons : attributes + commons
        left_a  = expr.left.attr_list & proj_a
        right_a = expr.right.attr_list & proj_a

        # make both projections
        left  = apply(expr.left, left_a, allbut, search)
        right = apply(expr.right, right_a, allbut, search)

        # re-apply the join
        rw = join(left, right)

        # add the outer projection unless the job has already been done
        unless attributes == (left_a + right_a)
          outside = allbut ? attributes - left_a - right_a : attributes
          rw = project(rw, outside, allbut: allbut)
        end

        rw
      end

      def on_binary_splitable(expr, attributes, allbut, search)
        commons = expr.left.attr_list & expr.right.attr_list

        # compute inside and outside projection attributes such as preserving
        # commons
        inside  = allbut ? attributes - commons : attributes + commons
        outside = allbut ? attributes - inside  : attributes

        # apply on left operand with inside attributes
        left  = apply(expr.left, inside, allbut, search)
        right = expr.right

        # rewrite it now
        rw = expr.class.new([left, right])

        # add the outside projection unless the job is already done by the
        # inside projection
        rw = project(rw, outside, allbut: allbut) unless inside == attributes

        rw
      end
      alias :on_matching     :on_binary_splitable
      alias :on_not_matching :on_binary_splitable

      def on_union(expr, attributes, allbut, search)
        left  = apply(expr.left, attributes, allbut, search)
        right = apply(expr.right, attributes, allbut, search)
        union(left, right)
      end

    end # class Project
  end # class Optimizer
end # module Alf
