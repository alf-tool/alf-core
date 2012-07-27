require_relative 'optimizer/processor'
require_relative 'optimizer/restrict'
module Alf
  class Optimizer

    def initialize(context = nil)
      @context = context
    end
    attr_reader :context

    def call(expr)
      processors.inject(expr) do |c, (p,k)|
        Search.new(p, k).call(c)
      end
    end

    class Search

      def initialize(processor, kind)
        @processor = processor
        @kind = kind
      end

      def call(expr)
        apply(expr)
      end

      def apply(expr)
        if expr.is_a?(@kind)
          @processor.call(expr)
        else
          expr.with_operands(*expr.operands.map{|op| apply(op)})
        end
      end

    end

  end # class Optimizer
end # module Alf