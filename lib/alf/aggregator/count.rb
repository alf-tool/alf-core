module Alf
  class Aggregator
    #
    # Defines a `count()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.count.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :num_orders => count)
    #
    class Count < Aggregator

      # Returns 0 as least value.
      #
      # @see Aggregator::InstanceMethods#least
      def least()
        0
      end

      # Aggregates on a tuple occurence through `memo + 1`
      #
      # @see Aggregator::InstanceMethods#happens
      def happens(memo, tuple) 
        memo + 1
      end

    end # class Count
  end # class Aggregator
end # module Alf
