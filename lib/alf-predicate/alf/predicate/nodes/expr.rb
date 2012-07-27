module Alf
  class Predicate
    module Expr

      module ProcMethods
        attr_writer :source_code
        def to_ruby_literal
          @source_code
        end
        alias :to_s :to_ruby_literal
        alias :inspect :to_ruby_literal
      end

      def to_ruby_code
        ToRubyCode.call(self)
      end

      def to_proc
        code = to_ruby_code
        code = "lambda{ #{code} }"
        proc = Kernel.eval(code)
        proc.extend(ProcMethods)
        proc.source_code = code
        proc
      end

      def _(arg)
        Factory._(arg)
      end

    end
  end
end
