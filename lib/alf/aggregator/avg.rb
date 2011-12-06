module Alf
  class Aggregator
    #
    # Defines a `avg()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.avg{ qty }.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :avg => avg{ qty })
    #
    class Avg < Aggregator

      # Returns [0.0, 0.0] as least value.
      #
      # @see Aggregator::InstanceMethods#least
      def least()
        [0.0, 0.0]
      end

      # Aggregates on a tuple occurence.
      #
      # @see Aggregator::InstanceMethods#_happens
      def _happens(memo, val) 
        [memo.first + val, memo.last + 1]
      end

      # Finalizes the computation.
      #
      # @see Aggregator::InstanceMethods#finalize
      def finalize(memo) 
        memo.first / memo.last 
      end

    end # class Avg
  end # class Aggregator
end # module Alf
