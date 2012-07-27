module Alf
  class Predicate
    module Expr

      def to_ruby_code(options = {})
        ToRubyCode.call(self, options)
      end

      def to_proc(options = {})
        ToProc.call(self, options)
      end

      def sexpr(arg)
        Factory.sexpr(arg)
      end

    end
  end
end
