module Alf
  module Engine
    class ToDot
      include Alf::Support::DotUtils

      def call(cog, buf = "")
        buf << "/* #{cog} */\n"
        buf << "digraph \"Alf\" {\n"
        buf << "node [width=0.375,height=0.25,shape=record];\n"
        apply(cog, buf)
        buf << "}\n"
        buf
      end

      def on_unary_operator(cog, buf, label)
        buf << "#{cog.object_id} [label=#{dot_label(label)}];\n"
        apply(cog.operand, buf)
        buf << "#{cog.object_id} -> #{cog.operand.object_id} [label=\"operand\"];\n"
      end

      def on_binary_operator(cog, buf, label)
        buf << "#{cog.object_id} [label=#{dot_label(label)}];\n"
        apply(cog.left, buf)
        apply(cog.right, buf)
        buf << "#{cog.object_id} -> #{cog.left.object_id} [label=\"left\"];\n"
        buf << "#{cog.object_id} -> #{cog.right.object_id} [label=\"right\"];\n"
      end

      def on_nary_operator(cog, buf, label)
        buf << "#{cog.object_id} [label=#{dot_label(label)}];\n"
        cog.operands.each_with_index do |op, i|
          apply(op, buf)
          buf << "#{cog.object_id} -> #{op.object_id} [label=#{dot_label(i)}];\n"
        end
      end

      def on_leaf_operand(cog, buf = "")
        case cog
        when Relation
          buf << "#{cog.object_id} [label=\"Relation\"];\n"
        else
          buf << "#{cog.object_id} [label=#{dot_label(cog)}];\n"
        end
      end

      def apply(cog, buf)
        if cog.respond_to?(:operand)
          on_unary_operator(cog, buf, cog.class.name)
        elsif cog.respond_to?(:left)
          on_binary_operator(cog, buf, cog.class.name)
        elsif cog.respond_to?(:operands)
          on_nary_operator(cog, buf, cog.class.name)
        else
          on_leaf_operand(cog, buf)
        end
      end

    end # class ToDot
  end # module Engine
end # module Alf
