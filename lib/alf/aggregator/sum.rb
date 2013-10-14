module Alf
  class Aggregator
    #
    # Defines a `sum()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.sum{ qty }.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :total => sum{ qty })
    #
    class Sum < Aggregator

      # Returns 0 as least value.
      #
      # @see Aggregator::InstanceMethods#least
      def least()
        0
      end

      # Aggregates on a tuple occurence through `memo + val`
      #
      # @see Aggregator::InstanceMethods#_happens
      def _happens(memo, val) 
        memo + val
      end

    end # class Sum
  end # class Aggregator
end # module Alf
