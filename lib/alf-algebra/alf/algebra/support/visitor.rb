module Alf
  module Algebra
    module Visitor

      def copy_and_apply(expr)
        if expr.is_a?(Algebra::Operator)
          expr.with_operands(*expr.operands.map{|op| apply(op) })
        else
          expr
        end
      end

    private

      def to_method_name(expr, prefix = "on_")
        case expr
        when Algebra::Operator
          name = Support.ruby_case(Support.class_name(expr.class))
          meth = :"#{prefix}#{name}"
          meth = :"#{prefix}missing" unless respond_to?(meth)
          meth
        when Algebra::Operand
          :on_leaf_operand
        else
          :not_supported
        end
      end

    end # module Visitor
  end # module Algebra
end # module Alf
