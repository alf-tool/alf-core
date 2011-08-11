module Alf
  class Aggregator
    module Base
      
      # @return [Hash] Aggregation options 
      attr_reader :options

      # @return [TupleExpression] the underlying functor
      attr_reader :functor

      # @return [String] source code of the aggregator, if any
      attr_accessor :source

      #
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
    
      #
      # Returns the default options to use
      #
      def default_options
        {}
      end
    
      #
      # Returns the least value, which is the one to use on an empty
      # set.
      #
      # This method is intended to be overriden by subclasses; default 
      # implementation returns nil.
      # 
      def least
        nil
      end
    
      # 
      # This method is called on each aggregated tuple and must return
      # an updated _memo_ value. It can be seen as the block typically
      # given to Enumerable.inject.
      #
      # The default implementation collects the pre-value on the tuple 
      # and delegates to _happens.
      #
      def happens(memo, tuple)
        _happens(memo, @functor.evaluate(@handle.set(tuple)))
      end
    
      #
      # This method finalizes a computation.
      #
      # Argument _memo_ is either _least_ or the result of aggregating 
      # through _happens_. The default implementation simply returns
      # _memo_. The method is intended to be overriden for complex 
      # aggregations that need statefull information. See Avg for an 
      # example 
      #
      def finalize(memo)
        memo
      end
    
      #
      # Aggregates over an enumeration of tuples. 
      #
      def aggregate(enum)
        finalize(
          enum.inject(least){|memo,tuple| 
            happens(memo, tuple)
          })
      end
    
      protected
    
      #
      # @see happens.
      #
      # This method is intended to be overriden and returns _value_
      # by default, making this aggregator a "Last" one...
      #
      def _happens(memo, value)
        value
      end
      
    end # module Base
    include(Base)
  end # class Aggregator
end # module Alf
