module Alf
  class Aggregator
    #
    # Defines a `max()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.max{ qty }.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :max => max{ qty })
    #
    class Max < Aggregator

      # Returns nil as least value.
      #
      # @see Aggregator::InstanceMethods#least
      def least()
        nil
      end

      # Aggregates on a tuple occurence through `memo > val ? memo : val`
      #
      # @see Aggregator::InstanceMethods#_happens
      def _happens(memo, val) 
        memo.nil? ? val : (memo > val ? memo : val) 
      end

    end # class Max
  end # class Aggregator
end # module Alf
