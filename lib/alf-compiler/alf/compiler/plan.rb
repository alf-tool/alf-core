require 'tsort'
module Alf
  class Compiler
    class Plan

      def initialize(compiler = Compiler.new)
        @parser        = Lang::Parser::Lispy.new
        @compilers     = {}
        @compiled      = {}
        @usage_count   = Hash.new{|h,k| h[k] = 0 }
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

      # Pre-visit
      def compile(sexpr)
        visit(sexpr)
        _compile(sexpr)
      end

      # Post-visit, pre-reuse
      def _compile(expr)
        compiled = @compiled[expr]
        return @compiled[expr] = __compile(expr) unless compiled
        return __compile(expr) unless compiler = compiled.compiler
        return __compile(expr) unless compiler.supports_reuse?
        compiler.reuse(self, compiled)
      end

      # Real compilation, post-reuse
      def __compile(expr = nil, compiled = nil, &bl)
        expr      ||= bl.call(parser)
        compiled  ||= children(expr).map{|op| _compile(op) }
        compiler    = compiler(compiled)
        usage_count = @usage_count[expr]
        compiler.compile(self, expr, compiled, usage_count)
      rescue NotSupportedError
        main_compiler.compile(self, expr, compiled, usage_count)
      end

      def recompile(*compiled, &bl)
        __compile(nil, compiled, &bl)
      end

      def visit(expr)
        @usage_count[expr] += 1
        children(expr).each{|op| visit(op) }
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
