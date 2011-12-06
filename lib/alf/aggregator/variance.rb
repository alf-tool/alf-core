module Alf
  class Aggregator
    #
    # Defines a `variance()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.variance{ qty }.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :total => variance{ qty })
    #
    class Variance < Aggregator

      # Returns the least value.
      #
      # @see Aggregator::InstanceMethods#least
      def least()
        [0, 0.0, 0.0]
      end

      # Aggregates on a tuple occurence.
      #
      # @see Aggregator::InstanceMethods#_happens
      def _happens(memo, val) 
        count, mean, m2 = memo
        count += 1
        delta = val - mean
        mean  += (delta / count)
        m2    += delta*(val - mean)
        [count, mean, m2]
      end

      # Finalizes the computation.
      #
      # @see Aggregator::InstanceMethods#finalize
      def finalize(memo) 
        count, mean, m2 = memo
        m2 / count
      end

    end # class Variance
  end # class Aggregator
end # module Alf
