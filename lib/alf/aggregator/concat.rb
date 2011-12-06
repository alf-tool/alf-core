module Alf
  class Aggregator
    #
    # Defines a `concat()` aggregation operator.
    #
    # Example:
    #
    #   # direct ruby usage
    #   Alf::Aggregator.concat{ qty }.aggregate(...)
    #
    #   # lispy 
    #   (summarize :supplies, [:sid], :cat => concat{ qty })
    #
    class Concat < Aggregator

      # Sets default options.
      #
      # @see Aggregator::InstanceMethods#default_options
      def default_options
        {:before => "", :after => "", :between => ""}
      end

      # Returns least value (defaults to "")
      #
      # @see Aggregator::InstanceMethods#least
      def least()
        ""
      end

      # Aggregates on a tuple occurence.
      #
      # @see Aggregator::InstanceMethods#_happens
      def _happens(memo, val) 
        memo << options[:between].to_s unless memo.empty?
        memo << val.to_s
      end

      # Finalizes computation
      #
      # @see Aggregator::InstanceMethods#finalize
      def finalize(memo)
        options[:before].to_s + memo + options[:after].to_s
      end

    end # class Concat
  end # class Aggregator
end # module Alf
