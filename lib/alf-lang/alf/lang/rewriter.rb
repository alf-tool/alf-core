module Alf
  module Lang
    class Rewriter
      include Visitor
      include Lang::Functional

    # public interface

      def call(expr, search = nil)
        apply(expr)
      end

    # utilities

      def copy_and_apply(expr)
        if expr.is_a?(Operator)
          expr.with_operands(*expr.operands.map{|op| apply(op)})
        else
          expr
        end
      end

    # copy all default implementation

      def apply(expr, *args, &bl)
        send to_method_name(expr, "on_"), expr, *args, &bl
      end

      def on_missing(expr, *args, &bl)
        copy_and_apply(expr, *args, &bl)
      end

    end # class Rewriter
  end # module Lang
end # module Alf