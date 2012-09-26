module Alf
  module Types
    #
    # Encapsulates a Summarization information.
    #
    class Summarization
      include Myrrha::Domain::Impl.new([:aggregations])

      coercions do |c|
        c.delegate :to_summarization
        c.coercion(Hash){|arg,_|
          Summarization.new Hash[arg.map{|k,v| [ AttrName.coerce(k), Aggregator.coerce(v) ] }]
        }
        c.coercion(Array){|arg,_|
          coerce(Hash[*arg])
        }
      end

      class << self

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
      # @return [Support::TupleScope] a scope bound to the current tuple
      def happens(aggs, scope)
        Hash[@aggregations.map{|k,v|
          [k, v.happens(aggs[k], scope)]
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
        scope = Support::TupleScope.new
        finalize(enum.inject(least){|m,t| happens(m, scope.__set_tuple(t))})
      end

      # Returns self
      def to_summarization
        self
      end

      # Converts to an Heading.
      #
      # @return [Heading] a heading
      def to_heading
        Heading.new Hash[aggregations.map{|name,agg| [name, agg.infer_type]}]
      end

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
        "Alf::Summarization[#{Support.to_ruby_literal(map)}]"
      end

      # Returns a string representation of this expression
      def inspect
        to_ruby_literal
      rescue NotImplementedError
        super
      end

    end # class Summarization
  end # module Types
end # module Alf
