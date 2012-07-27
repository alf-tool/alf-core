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

      def to_ruby_code(options = {})
        ToRubyCode.call(self, options)
      end

      def to_proc(options = {})
        code = to_ruby_code(options)
        if s = options[:scope]
          code = "lambda{|#{s}| #{code} }"
        else
          code = "lambda{ #{code} }"
        end
        Kernel.eval(code).
               extend(ProcMethods).tap do |proc|
          proc.source_code = code
        end
      end

      def _(arg)
        Factory._(arg)
      end

    end
  end
end
