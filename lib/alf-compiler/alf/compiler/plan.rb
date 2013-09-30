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

        def each_child(&bl)
          children.each(&bl)
        end

        def to_s
          "SubPlan: `#{expr}`"
        end

      end # class SubPlan

      def initialize(compiler)
        @parser = Lang::Lispy.new
        @compiler = compiler
        @subplans = {}
      end
      attr_reader :parser, :compiler

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
          compiler._call(self, expr, subplan.cogs)
        end
      end

    end # class Plan
  end # class Compiler
end # module Alf
