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
    class Filter < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Predicate] Filtering predicate
      attr_reader :predicate

      # Creates a Filter instance
      def initialize(operand, predicate, context=nil)
        super(context)
        @operand = operand
        @predicate = predicate
      end

      # (see Cog#each)
      def each
        scope = tuple_scope
        operand.each do |tuple|
          yield(tuple) if @predicate.evaluate(scope.__set_tuple(tuple))
        end
      end

    end # class Filter
  end # module Engine
end # module Alf
