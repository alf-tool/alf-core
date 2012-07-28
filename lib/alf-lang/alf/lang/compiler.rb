module Alf
  module Lang
    class Compiler
      include Visitor

    # public interface

      def call(expr)
        apply(expr)
      end

    # copy all default implementation

      def apply(expr, *args, &bl)
        send to_method_name(expr, "on_"), expr, *args, &bl
      end

      def on_missing(expr, *args, &bl)
        raise NotSupportedError, "Unable to compile `#{expr}`"
      end

      def on_outside(expr, *args, &bl)
        if expr.respond_to?(:each)
          expr
        else
          raise NotSupportedError, "Unable to compile `#{expr}`"
        end
      end

    end # class Compiler
  end # module Lang
end # module Alf