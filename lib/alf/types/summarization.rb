module Alf
  module Types
    #
    # Encapsulates a Summarization information.
    #
    class Summarization

      # @return [Hash] the hash of aggregations, AttrName -> Aggregators
      attr_reader :aggregations

      # Creates a Summarization instance
      #
      # @param [Hash] aggs, aggregations as a mapping AttrName -> Aggregators
      def initialize(aggs)
        @aggregations = aggs
      end

      class << self

        # Coerces `arg` to an Summarization
        #
        # Implemented coercions are:
        # - Summarization        -> self
        # - [attr1, agg1, ...]   -> {AttrName(attr1) -> Aggregator(agg1), ...}
        # - {attr1 => agg1, ...} -> {AttrName(attr1) -> Aggregator(agg1), ...}
        # 
        # @param [Object] arg any ruby object to coerce to an Summarization
        # @return [Summarization] the coerced summarization
        # @raise [ArgumentError] is the coercion fails
        def coerce(arg)
          case arg
          when Summarization
            arg
          when Array
            coerce(Hash[*arg])
          when Hash
            Summarization.new Hash[arg.map{|k,v|
              [ Tools.coerce(k, AttrName), 
                Tools.coerce(v, Aggregator) ]
            }]
          else
            raise ArgumentError, "Invalid arg `#{arg}` for Summarization()"
          end
        end
        alias :[] :coerce

        # Coerces commandline arguments to a Summarization
        #
        # This method reuses `coerce(Array)` and therefore shares its spec.
        #
        # @params [Array<String>] argv commandline arguments
        # @params [Hash] opts coercion options (not used)
        # @return [Summarization] the coerced summarization
        # @raise [ArgumentError] is the coercion fails
        def from_argv(argv, opts = {})
          coerce(argv)
        end

      end

      # Computes the least tuple.
      #
      # @return [Tuple] a tuple with least values for each attribute
      def least
        Hash[@aggregations.map{|k,v| 
          [k, v.least]
        }]
      end

      # Computes the resulting aggregation from aggs if tuple happens.
      #
      # @return [Tuple] the new aggregated tuple
      def happens(aggs, tuple)
        Hash[@aggregations.map{|k,v|
          [k, v.happens(aggs[k], tuple)]
        }]
      end

      # Finalizes the summarization
      #
      # @return [Tuple] the finalized aggregated tuple
      def finalize(aggs)
        Hash[@aggregations.map{|k,v|
          [k, v.finalize(aggs[k])]
        }]
      end

      # Summarizes an enumeration of tuples.
      #
      # @param [Enumerable] enum an enumeration of tuples
      # @returns [Tuple] The summarization of `enum`
      def summarize(enum)
        finalize(enum.inject(least){|m,t| happens(m,t)})
      end

      # Returns a hash code.
      #
      # @return [Integer] a hash code for this expression
      def hash
        aggregations.hash
      end

      # Checks equality with another summarization
      #
      # @param [Summarization] another summariation
      # @return [Boolean] true is self and other are equal, false otherwise
      def ==(other)
        other.is_a?(Summarization) && (other.aggregations == aggregations)
      end
      alias :eql? :==

      # Converts to an attribute list.
      #
      # @return [AttrList] a list of computed attribute names
      def to_attr_list
        AttrList.new(aggregations.keys)
      end

      # Returns a ruby literal for this expression.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        map = Hash[aggregations.map{|k,v| 
          [k.to_s, "#{v.has_source_code!}"]
        }]
        "Alf::Summarization[#{Tools.to_ruby_literal(map)}]"
      end
      alias :inspect :to_ruby_literal

    end # class Summarization
  end # module Types
end # module Alf
