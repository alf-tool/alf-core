module Alf
  module Algebra
    class Rewriter
      include Visitor

    # public interface

      def call(expr, search = nil)
        apply(expr)
      end

    # copy all default implementation

      def apply(expr, *args, &bl)
        send to_method_name(expr, "on_"), expr, *args, &bl
      end

      def on_leaf_operand(expr, *args, &bl)
        expr
      end

      def on_shortcut(expr, *args, &bl)
        apply(expr.expand, *args, &bl)
      end

      def on_missing(expr, *args, &bl)
        copy_and_apply(expr, *args, &bl)
      end

      def not_supported(expr, *args, &bl)
        raise NotSupportedError, "Unexpected operand `#{expr}`"
      end

    end # class Rewriter
  end # module Algebra
end # module Alf