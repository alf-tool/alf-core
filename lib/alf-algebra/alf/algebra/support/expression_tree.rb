module Alf
  module Algebra
    class ExpressionTree < Support::Tree

      EMPTY_CHILDREN = [].freeze

      def label(node)
        case node
        when Relation::DEE  then "DEE"
        when Relation::DUM  then "DUM"
        when Operand::Named then node.name.to_s
        when Operand::Fake  then node.name.to_s
        when Operator       then operator_label(node)
        else
          node.to_s
        end
      end

      def operator_label(node)
        label = ""
        label << node.class.rubycase_name.to_s
        datasets, arguments, options = node.signature.collect_on(node)
        arguments.each_with_index do |arg,i|
          label << (i == 0 ? " " : ", ")
          label << argument_label(arg)
        end
        unless options.nil? or options.empty?
          label << (arguments.empty? ? " " : ", ")
          label << options_label(options)
        end
        label
      end

      def argument_label(arg)
        Alf::Support.to_lispy(arg)
      rescue NotSupportedError
        "[code unavailable]"
      end

      def options_label(options)
        Alf::Support.to_lispy(options)
      rescue NotSupportedError
        "[code unavailable]"
      end

      def children(node)
        return EMPTY_CHILDREN unless node.is_a?(Operator)
        node.operands
      end

    end # ExpressionTree
  end # module Algebra
end # module Alf
