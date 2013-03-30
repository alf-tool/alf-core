module Alf
  module Algebra
    class ToDot < Compiler

      def call(expr, buf = "")
        buf << "/* #{expr} */\n"
        buf << "digraph \"Alf\" {\n"
        buf << "node [width=0.375,height=0.25,shape=record];\n"
        super
        buf << "}\n"
        buf
      end

      def on_unary_operator(expr, buf, label)
        buf << "#{expr.object_id} [label=#{lbl(label)}];\n"
        apply(expr.operand, buf)
        buf << "#{expr.object_id} -> #{expr.operand.object_id} [label=\"operand\"];\n"
      end

      def on_binary_operator(expr, buf, label)
        buf << "#{expr.object_id} [label=#{lbl(label)}];\n"
        apply(expr.left, buf)
        apply(expr.right, buf)
        buf << "#{expr.object_id} -> #{expr.left.object_id} [label=\"left\"];\n"
        buf << "#{expr.object_id} -> #{expr.right.object_id} [label=\"right\"];\n"
      end

      def on_leaf_operand(expr, buf = "")
        case expr
        when Operand::Named
          buf << "#{expr.object_id} [label=#{lbl(expr.name)}];\n"
        when Operand::Proxy
          buf << "#{expr.object_id} [label=#{lbl(expr.subject)}];\n"
        when Relvar::Virtual
          buf << "#{expr.object_id} [label=\"Relvar::Virtual\"];\n"
          apply(expr.expr, buf)
          buf << "#{expr.object_id} -> #{expr.expr.object_id} [label=\"definition\"];\n"
        when Relation
          buf << "#{expr.object_id} [label=\"Relation\"];\n"
        else
          buf << "#{expr.object_id} [label=#{lbl(expr)}];\n"
        end
      end

      ###

      def on_autonum(expr, buf = "")
        on_unary_operator(expr, buf, "Autonum|#{as(expr)}")
      end

      def on_clip(expr, buf = "")
        on_unary_operator(expr, buf, "Clip|#{allbut(expr)}#{attributes(expr)}")
      end

      def on_coerce(expr, buf = "")
        on_unary_operator(expr, buf, "Coerce|#{expr.coercions}")
      end

      def on_compact(expr, buf = "")
        on_unary_operator(expr, buf, "Compact")
      end

      def on_defaults(expr, buf = "")
        on_unary_operator(expr, buf, "Defaults|#{strict}#{expr.defaults}")
      end

      def on_extend(expr, buf = "")
        on_unary_operator(expr, buf, "Extend|#{expr.ext}")
      end

      def on_generator(expr, buf = "")
        on_unary_operator(expr, buf, "Generator|#{expr.size}#{as(expr)}")
      end

      def on_group(expr, buf = "")
        on_unary_operator(expr, buf, "Group|#{allbut(expr)}#{attributes(expr)}#{as(expr)}")
      end

      def on_infer_heading(expr, buf = "")
        on_unary_operator(expr, buf, "InferHeading")
      end

      def on_intersect(expr, buf = "")
        on_binary_operator(expr, buf, "Intersect")
      end

      def on_join(expr, buf = "")
        on_binary_operator(expr, buf, "Join")
      end

      def on_matching(expr, buf = "")
        on_binary_operator(expr, buf, "Matching")
      end

      def on_minus(expr, buf = "")
        on_binary_operator(expr, buf, "Minus")
      end

      def on_not_matching(expr, buf = "")
        on_binary_operator(expr, buf, "NotMatching")
      end

      def on_project(expr, buf = "")
        on_unary_operator(expr, buf, "Project|#{allbut(expr)}#{attributes(expr)}")
      end

      def on_quota(expr, buf = "")
        on_unary_operator(expr, buf, "Quota|#{by(expr)}")
      end

      def on_rank(expr, buf = "")
        on_unary_operator(expr, buf, "Rank|#{order(expr)}#{as(expr)}")
      end

      def on_rename(expr, buf = "")
        on_unary_operator(expr, buf, "Rename|#{renaming(expr)}")
      end

      def on_restrict(expr, buf = "")
        on_unary_operator(expr, buf, "Restrict|#{predicate(expr)}")
      end

      def on_sort(expr, buf = "")
        on_unary_operator(expr, buf, "Sort|#{ordering(expr)}")
      end

      def on_summarize(expr, buf = "")
        on_unary_operator(expr, buf, "Sumarize|#{allbut(expr)}#{by(expr)}")
      end

      def on_type_safe(expr, buf = "")
        on_unary_operator(expr, buf, "TypeSafe|#{strict(expr)}#{heading(expr)}")
      end

      def on_ungroup(expr, buf = "")
        on_unary_operator(expr, buf, "Ungroup|#{expr.attribute}")
      end

      def on_union(expr, buf = "")
        on_binary_operator(expr, buf, "Union")
      end

      def on_unwrap(expr, buf = "")
        on_unary_operator(expr, buf, "Unwrap|#{expr.attribute}")
      end

      def on_wrap(expr, buf = "")
        on_unary_operator(expr, buf, "Wrap|#{allbut(expr)}#{attributes(expr)}#{as(expr)}")
      end

    private

      def allbut(expr)
        expr.allbut ? 'allbut ' : ''
      end

      def as(expr)
        "|#{expr.as}"
      end

      def attributes(expr)
        "#{expr.attributes.to_a.join(',')}"
      end

      def by(expr)
        "#{expr.by}"
      end

      def order(expr)
        "#{expr.ordering}"
      end

      def renaming(expr)
        "#{expr.renaming}"
      end

      def predicate(expr)
        "#{expr.predicate}"
      end

      def heading(expr)
        "#{expr.heading}"
      end

      def ordering(expr)
        "#{expr.ordering}"
      end

      def strict(expr)
        expr.strict ? "strict " : ''
      end

      def lbl(label)
        %Q{"#{label.to_s[0..100].gsub(/"/, '\"').gsub(/\n/, '\n')}"}
      end

    end # class ToDot
  end # module Algebra
end # module Alf
