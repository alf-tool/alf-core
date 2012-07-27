module Alf
  class Predicate
    module Expr

      def to_ruby_code
        ToRubyCode.call(self)
      end

      def to_proc
        ToProc.call(self)
      end

      def _(arg)
        Factory._(arg)
      end

    end
  end
end
