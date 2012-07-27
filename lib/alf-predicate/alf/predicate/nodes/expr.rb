module Alf
  class Predicate
    module Expr

      def to_ruby_code(options = {})
        ToRubyCode.call(self, options)
      end

      def _(arg)
        Factory._(arg)
      end

    end
  end
end
