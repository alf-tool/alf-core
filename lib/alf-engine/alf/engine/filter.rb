module Alf
  module Engine
    #
    # Filters operand using a tuple predicate.
    #
    # Example
    #
    #     rel = [
    #       {:name => "Smith"},
    #       {:name => "Jones"}
    #     ]
    #     Filter.new(rel, Predicate.parse("name =~ /^J/")).to_a
    #     # => [
    #     #      {:name => "Jones"}
    #     #    ]
    #
    class Filter
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Predicate] Filtering predicate
      attr_reader :predicate

      # Creates a Filter instance
      def initialize(operand, predicate, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @predicate = predicate
      end

      # (see Cog#each)
      def _each
        scope = tuple_scope
        operand.each do |tuple|
          t, c = scope.__set_tuple(tuple), expr && expr.connection
          yield(tuple) if @predicate.evaluate(t, c)
        end
      end

    end # class Filter
  end # module Engine
end # module Alf
