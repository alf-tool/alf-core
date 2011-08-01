module Alf
  module Types
    #
    # Encapsulates a Summarization information
    #
    class Summarization
      
      # @return [Hash] the hash of aggregations, AttrName -> Aggregators
      attr_reader :aggregations
      
      #
      # Creates a Summarization instance
      #
      # @param [Hash] aggs, aggregations as a mapping AttrName -> Aggregators
      #
      def initialize(aggs)
        @aggregations = aggs
      end
      
      #
      # Coerces `arg` to an Aggregator
      #
      def self.coerce(arg)
        case arg
        when Summarization
          arg
        when Array
          coerce(Hash[*arg])
        when Hash
          h = Tools.tuple_collect(arg) do |k,v|
            [Tools.coerce(k, AttrName), Tools.coerce(v, Aggregator)]
          end
          Summarization.new(h)
        else
          raise ArgumentError, "Invalid arg `#{arg}` for Summarization()"
        end
      end
      
      def self.from_argv(argv, opts = {})
        coerce(argv)
      end
      
      #
      # Computes the least tuple
      #
      def least
        Tools.tuple_collect(@aggregations){|k,v| 
          [k, v.least]
        }
      end
      
      #
      # Computes the resulting aggregation from aggs if tuple happens. 
      #
      def happens(aggs, tuple)
        Tools.tuple_collect(@aggregations){|k,v|
          [k, v.happens(aggs[k], tuple)]
        }
      end
      
      #
      # Finalizes the summarization `aggs` 
      #
      def finalize(aggs)
        Tools.tuple_collect(@aggregations){|k,v|
          [k, v.finalize(aggs[k])]
        }
      end
      
      def ==(other)
        other.is_a?(Summarization) && (other.aggregations == aggregations)
      end
      
    end # class Summarization
  end # module Types
end # module Alf