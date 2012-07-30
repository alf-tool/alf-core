module Alf
  module Engine
    #
    # Aggregates the whole operand according to a Summarization. The resulting
    # iterator contains only one tuple.
    #
    # Example:
    #
    #   res = [
    #     {:name => "Jones", :price => 12.0, :id => 1},
    #     {:name => "Smith", :price => 10.0, :id => 2}
    #   ]
    #   agg = Summarization[:size  => "count", 
    #                       :total => "sum{ price }"]
    #   Aggregate.new(res, agg).to_a
    #   # => [
    #   #      {:size => 2, :total => 22.0}
    #   #    ]
    #
    class Aggregate < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Summarization] The summarization to use
      attr_reader :summarization

      # Creates an Aggregate instance
      def initialize(operand, summarization)
        @operand = operand
        @summarization = summarization
      end

      # (see Cog#each)
      def each
        scope = tuple_scope
        agg = operand.inject(@summarization.least) do |memo,tuple|
          @summarization.happens(memo, scope.__set_tuple(tuple))
        end
        yield @summarization.finalize(agg)
      end

    end # class Aggregate
  end # Engine
end # module Alf
