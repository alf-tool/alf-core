module Alf
  module Types
    #
    # Encapsulates a Summarization information.
    #
    class Summarization
      extend Domain::Reuse.new(Hash)

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
      end

      reuse :map, :keys, :to_hash
      private :keys

      # Computes the least tuple.
      #
      # @return [Tuple] a tuple with least values for each attribute
      def least
        hmap{|k,v| v.least }
      end

      # Computes the resulting aggregation from aggs if tuple happens.
      #
      # @return [Support::TupleScope] a scope bound to the current tuple
      def happens(aggs, scope)
        hmap{|k,v| v.happens(aggs[k], scope) }
      end

      # Finalizes the summarization
      #
      # @return [Tuple] the finalized aggregated tuple
      def finalize(aggs)
        hmap{|k,v| v.finalize(aggs[k]) }
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
        Heading.new hmap{|name,agg| agg.infer_type}
      end

      # Converts to an attribute list.
      #
      # @return [AttrList] a list of computed attribute names
      def to_attr_list
        AttrList.new(keys)
      end

      # Returns a ruby literal for this expression.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        map = hmap{|k,v| "#{v.has_source_code!}" }
        "Alf::Summarization[#{Support.to_ruby_literal(map)}]"
      end

      # Returns a string representation of this expression
      def inspect
        to_ruby_literal
      rescue NotImplementedError
        super
      end

    private

      def hmap(&bl)
        map.each_with_object({}){|(k,v),h| h[k] = yield(k,v)}
      end

    end # class Summarization
  end # module Types
end # module Alf
