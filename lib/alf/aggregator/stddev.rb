module Alf
  class Aggregator
    #
    # Defines a `stddev()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.stddev{ qty }.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :stddev => stddev{ qty })
    #
    class Stddev < Variance

      # Finalizes the computation.
      #
      # @see Aggregator::InstanceMethods#finalize
      def finalize(memo) 
        Math.sqrt(super(memo))
      end

    end # class Stddev
  end # class Aggregator
end # module Alf
