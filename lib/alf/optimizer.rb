module Alf
  class Optimizer

    def initialize
      @processors = []
    end

    def call(expr)
      @processors.inject(expr){|c,p| p.call(c) }
    end

    def register(processor)
      @processors << processor
      self
    end

    class Base < Algebra::Rewriter
      include Lang::Functional

      def call(expr, search = nil)
        return Search.new(self, search_predicate).call(expr) unless search
        _call(expr, search)
      end
    end

    class Search < Algebra::Rewriter

      def initialize(processor, interest)
        @processor = processor
        @interest = interest
      end

      def apply(expr)
        if @interest === expr
          @processor.call(expr, self)
        else
          super
        end
      end

    end # class Search

  end # class Optimizer
end # module Alf
require_relative 'optimizer/restrict'
require_relative 'optimizer/project'
