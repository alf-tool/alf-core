module Alf
  module Lang
    module Visitor

    private

      def to_method_name(expr, prefix = "on_")
        case expr
        when Operator, Operator::VarRef
          name = Tools.ruby_case(Tools.class_name(expr.class))
          meth = :"#{prefix}#{name}"
          meth = :"#{prefix}missing" unless respond_to?(meth)
          meth
        else
          :"#{prefix}outside"
        end
      end

    end # module Visitor
  end # module Lang
end # module Alf