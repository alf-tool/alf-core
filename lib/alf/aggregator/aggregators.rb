module Alf
  class Aggregator
    require 'alf/aggregator/count'
    require 'alf/aggregator/sum'

    # 
    # Defines an AVG aggregation operator
    #
    class Avg < Aggregator
      def least(); [0.0, 0.0]; end
      def _happens(memo, val) [memo.first + val, memo.last + 1]; end
      def finalize(memo) memo.first / memo.last end
    end # class Sum

    # 
    # Defines a variance aggregation operator
    #
    class Variance < Aggregator
      def least(); [0, 0.0, 0.0]; end
      def _happens(memo, x) 
        count, mean, m2 = memo
        count += 1
        delta = x - mean
        mean  += (delta / count)
        m2    += delta*(x - mean)
        [count, mean, m2]
      end
      def finalize(memo) 
        count, mean, m2 = memo
        m2 / count
      end
    end # class Variance
  
    # 
    # Defines an standard deviation aggregation operator
    #
    class Stddev < Variance
      def finalize(memo) 
        Math.sqrt(super(memo))
      end
    end # class Stddev
  
    # 
    # Defines a MIN aggregation operator
    #
    class Min < Aggregator
      def least(); nil; end
      def _happens(memo, val) 
        memo.nil? ? val : (memo < val ? memo : val) 
      end
    end # class Min
  
    # 
    # Defines a MAX aggregation operator
    #
    class Max < Aggregator
      def least(); nil; end
      def _happens(memo, val) 
        memo.nil? ? val : (memo > val ? memo : val) 
      end
    end # class Max
    
    #
    # Defines a COLLECT aggregation operator
    #
    class Collect < Aggregator
      def least(); []; end
      def _happens(memo, val) 
        memo << val
      end
    end
  
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
