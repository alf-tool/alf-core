require 'tsort'
module Alf
  class Compiler
    class Plan

      class SubPlan < Struct.new(:plan, :expr, :cog)

        EMPTY_CHILDREN = []

        def children
          return EMPTY_CHILDREN unless expr.is_a?(Algebra::Operator)
          @children ||= expr.operands.map{|op| plan[op] }
        end

        def cogs
          @cogs ||= children.map(&:cog)
        end

        def compilers
          cogs.map(&:compiler).uniq
        end

        def each_child(&bl)
          children.each(&bl)
        end

        def to_s
          "SubPlan: `#{expr}`"
        end

      end # class SubPlan

      def initialize(compiler = Compiler.new)
        @parser        = Lang::Lispy.new
        @compilers     = {}
        @main_compiler = compiler
        @subplans      = {}
        join(compiler)
      end
      attr_reader :parser

      def join(compiler)
        @compilers[compiler] ||= compiler.join(self)
        compiler
      end

      def options(compiler)
        @compilers[compiler]
      end

      def [](expr)
        @subplans[expr] ||= SubPlan.new(self, expr, nil)
      end

      def compile(expr = nil, &bl)
        expr ||= bl.call(parser)
        subplan = self[expr]
        subplan.cog ||= begin
          subplan.each_child do |child|
            child.cog ||= compile(child.expr)
          end
          compiler = compiler(subplan)
          compiler.compile(self, expr, subplan.cogs){
            main_compiler.compile(self, expr, subplan.cogs)
          }
        end
      end

      def main_compiler
        @main_compiler
      end

      def compiler(subplan)
        candidates = subplan.compilers
        candidates.size > 1 ? main_compiler \
                            : candidates.first || main_compiler
      end

    end # class Plan
  end # class Compiler
end # module Alf
