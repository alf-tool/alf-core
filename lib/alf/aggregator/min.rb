module Alf
  class Aggregator
    #
    # Defines a `min()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.min{ qty }.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :max => min{ qty })
    #
    class Min < Aggregator

      # Returns nil as least value.
      #
      # @see Aggregator::InstanceMethods#least
      def least()
        nil
      end

      # Aggregates on a tuple occurence through `memo < val ? memo : val`
      #
      # @see Aggregator::InstanceMethods#_happens
      def _happens(memo, val) 
        memo.nil? ? val : (memo < val ? memo : val)
      end

    end # class Min
  end # class Aggregator
end # module Alf
