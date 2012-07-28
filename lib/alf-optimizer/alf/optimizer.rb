require_relative 'optimizer/restrict'
module Alf
  class Optimizer

    def initialize(context = nil)
      @context    = context
      @processors = []
    end
    attr_reader :context

    def call(expr)
      @processors.inject(expr) do |c, (p,k)|
        Search.new(p, k).call(c)
      end
    end

    def register(processor, interest)
      @processors << [processor, interest]
      self
    end

    class Search < Lang::Rewriter

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