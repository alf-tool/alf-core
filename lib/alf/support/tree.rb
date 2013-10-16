module Alf
  module Support
    class Tree

      EMPTY_CHILDREN = [].freeze

      def initialize(root)
        @root = root
      end
      attr_reader :root

      def label(node)
        case node
        when Sexpr                   then node.first.to_s
        when Algebra::Operand::Proxy then label(node.subject)
        when Relation::DUM           then "DUM"
        when Relation::DEE           then "DEE"
        when Relation                then "Relation(...)"
        when Relvar                  then "#{node.class} ..."
        else node.to_s
        end
      end

      def children(node)
        case node
        when Sexpr             then node.sexpr_body
        when Relvar            then [node.expr]
        when Algebra::Operator then node.operands
        when Algebra::Operand  then EMPTY_CHILDREN
        when Engine::Cog       then node.children
        else EMPTY_CHILDREN
        end
      end

      def to_text(buffer = '', node = root, depth = 0, open = [])
        depth.times do |i|
          buffer << ((i==depth-1) ? "+-- " : (open[i] ? "|  " : '   '))
        end
        buffer << label(node) << "\n"
        children = children(node)
        children.each_with_index do |child, index|
          open[depth] = (index != children.size-1)
          to_text(buffer, child, depth+1, open)
        end
        buffer
      end
      alias :to_s :to_text

    end # class Tree
  end # module Support
end # module Alf
