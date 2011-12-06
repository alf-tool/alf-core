module Alf
  class Aggregator
    require 'alf/aggregator/count'
    require 'alf/aggregator/sum'
    require 'alf/aggregator/min'
    require 'alf/aggregator/max'
    require 'alf/aggregator/avg'
    require 'alf/aggregator/variance'
    require 'alf/aggregator/collect'

    # 
    # Defines an standard deviation aggregation operator
    #
    class Stddev < Variance
      def finalize(memo) 
        Math.sqrt(super(memo))
      end
    end # class Stddev

    # 
    # Defines a CONCAT aggregation operator
    # 
    class Concat < Aggregator
      def least(); ""; end
      def default_options
        {:before => "", :after => "", :between => ""}
      end
      def _happens(memo, val) 
        memo << options[:between].to_s unless memo.empty?
        memo << val.to_s
      end
      def finalize(memo)
        options[:before].to_s + memo + options[:after].to_s
      end
    end
  
  end # class Aggregator
end # module Alf
