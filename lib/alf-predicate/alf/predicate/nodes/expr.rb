module Alf
  class Predicate
    module Expr

      def to_ruby_code
        ToRubyCode.call(self)
      end

      def to_proc
        ToProc.call(self)
      end

      def sexpr(arg)
        Factory.sexpr(arg)
      end

    end
  end
end
