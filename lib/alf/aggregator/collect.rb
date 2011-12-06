module Alf
  class Aggregator
    #
    # Defines a `collect()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.collect{ qty }.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :col => collect{ qty })
    #
    class Collect < Aggregator

      # Returns [] as least value.
      #
      # @see Aggregator::InstanceMethods#least
      def least()
        []
      end

      # Aggregates on a tuple occurence.
      #
      # @see Aggregator::InstanceMethods#_happens
      def _happens(memo, val) 
        memo << val
      end

    end # class Collect
  end # class Aggregator
end # module Alf
