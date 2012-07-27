module Alf
  class Predicate
    class ToProc

      module ProcMethods
        attr_writer :source_code
        def to_ruby_literal
          @source_code
        end
        alias :to_s :to_ruby_literal
        alias :inspect :to_ruby_literal
      end

      def self.call(expr)
        code = "lambda{ #{to_ruby_code(expr)} }"
        proc = Kernel.eval(code)
        proc.extend(ProcMethods)
        proc.source_code = code
        proc
      end

    private

      def self.to_ruby_code(expr)
        case expr
        when String then expr
        when Expr   then ToRubyCode.call(expr)
        else
          raise ArgumentError, "Unable to convert `#{expr}` to ruby source code"
        end
      end

    end
  end
end