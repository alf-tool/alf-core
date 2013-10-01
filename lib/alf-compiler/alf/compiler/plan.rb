require 'tsort'
module Alf
  class Compiler
    class Plan

      def initialize(compiler = Compiler.new)
        @parser        = Lang::Lispy.new
        @compilers     = {}
        @main_compiler = compiler
        join(compiler)
      end
      attr_reader :parser, :main_compiler

      def join(compiler)
        @compilers[compiler] ||= compiler.join(self)
        compiler
      end

      def options(compiler)
        @compilers[compiler]
      end

      def parse(&bl)
        bl.call(parser)
      end

      def compile(expr = nil, compiled = nil, &bl)
        expr     ||= bl.call(parser)
        compiled ||= children(expr).map{|op| compile(op) }
        compiler   = compiler(compiled)
        compiler.compile(self, expr, compiled)
      rescue NotSupportedError
        main_compiler.compile(self, expr, compiled)
      end

      def recompile(*compiled, &bl)
        compile(nil, compiled, &bl)
      end

    private

      EMPTY_CHILDREN = []

      def children(expr)
        return EMPTY_CHILDREN unless expr.is_a?(Algebra::Operator)
        expr.operands
      end

      def compiler(compiled)
        candidates = compiled.map(&:compiler).uniq
        candidates.size > 1 ? main_compiler \
                            : candidates.first || main_compiler
      end

    end # class Plan
  end # class Compiler
end # module Alf
