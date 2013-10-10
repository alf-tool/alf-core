module Alf
  module Algebra
    class ExpressionTree < Support::Tree

      EMPTY_CHILDREN = [].freeze

      def label(node)
        case node
        when Relation::DUM then "DUM"
        when Relation::DEE then "DEE"
        else node.to_s
        end
      end

      def children(node)
        return EMPTY_CHILDREN unless node.is_a?(Operator)
        node.operands
      end

    end # ExpressionTree
  end # module Algebra
end # module Alf
