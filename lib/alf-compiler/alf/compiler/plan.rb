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

        def children_cogs
          @cogs ||= children.map(&:cog)
        end

        def children_compilers
          children_cogs.map(&:compiler).uniq
        end

        def compiler
          candidates = children_compilers
          candidates.size > 1 ? plan.main_compiler \
                              : candidates.first || plan.main_compiler
        end

        def cog
          @cog ||= compiler.compile(plan, expr, children_cogs){
            plan.main_compiler.compile(plan, expr, children_cogs)
          }
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
      attr_reader :parser, :main_compiler

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
        self[expr || bl.call(parser)].cog
      end

    end # class Plan
  end # class Compiler
end # module Alf
