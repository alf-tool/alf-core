module Alf
  class Aggregator
    #
    # This module defines methods for the default implementation of Alf's 
    # aggregators.
    #
    module InstanceMethods

      # @return [Hash] Aggregation options 
      attr_reader :options

      # @return [TupleExpression] the underlying functor
      attr_reader :functor

      # @return [String] source code of the aggregator, if any
      attr_accessor :source

      # Creates an Aggregator instance.
      #
      # Example:
      #
      #   Aggregator.new{ size * price }
      #
      def initialize(options = {}, &block)
        @handle = Tools::TupleHandle.new
        @options = default_options.merge(options)
        @functor = Tools.coerce(block, TupleExpression)
      end

      # Returns the default options to use
      #
      # @return [Hash] the default aggregation options
      def default_options
        {}
      end

      # Returns the least value, which is the one to use on an empty
      # set.
      #
      # This method is intended to be overriden by subclasses; default 
      # implementation returns nil.
      #
      # @return [Object] the least value for this aggregator
      def least
        nil
      end

      # This method is called on each aggregated tuple and must return
      # an updated _memo_ value. It can be seen as the block typically
      # given to Enumerable.inject.
      #
      # The default implementation collects the pre-value on the tuple 
      # and delegates to _happens.
      #
      # @param [Object] memo the current aggregation value
      # @param [Hash] tuple the current iterated tuple
      # @return [Object] updated memo value
      def happens(memo, tuple)
        _happens(memo, @functor.evaluate(@handle.set(tuple)))
      end

      # This method finalizes an aggregation.
      #
      # Argument _memo_ is either _least_ or the result of aggregating 
      # through _happens_. The default implementation simply returns
      # _memo_. The method is intended to be overriden for complex 
      # aggregations that need statefull information such as `avg`.
      #
      # @param [Object] memo the current aggregation value
      # @return [Object] the aggregation value, as finalized
      def finalize(memo)
        memo
      end

      # Aggregates over an enumeration of tuples.
      #
      # @param [Enumerable<Tuple>] an enumerable of tuples
      # @return [Object] the computed aggregation value
      def aggregate(enum)
        finalize(enum.inject(least){|m,t| happens(m, t)})
      end

      protected

      # @see happens.
      #
      # This method is intended to be overriden and returns _value_
      # by default, making this aggregator a "Last(...)" aggregator.
      def _happens(memo, value)
        value
      end

    end # module InstanceMethods
    include(InstanceMethods)
  end # class Aggregator
end # module Alf
