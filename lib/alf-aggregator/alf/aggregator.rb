module Alf
  #
  # Aggregation operator.
  #
  # This class provides a basis for implementing aggregation operators. It should always
  # be used as a superclass for such implementations.
  #
  # Aggregation operators are made available through factory methods on the
  # Aggregator class itself:
  #
  #     Aggregator.count
  #     Aggregator.sum{ qty }
  #
  # The coercion method should always be used for building aggregators from
  # lispy source code:
  #
  #     Aggregator.coerce("count")
  #     Aggregator.coerce("sum{ qty }")
  #
  # Once built, aggregators can be used either in black-box or white-box modes.
  #
  #     relation = ...
  #     agg = Aggregator.sum{ qty }
  #
  #     # Black box mode:
  #     result = agg.aggregate(relation)
  #
  #     # White box mode:
  #     memo = agg.least
  #     relation.each do |tuple|
  #       memo = agg.happens(memo, tuple)
  #     end
  #     result = agg.finalize(memo)
  #
  class Aggregator

    #
    # Class-level utilities of Alf's aggregators.
    #
    # Subclasses of Aggregator are automatically tracked so as to add
    # factory methods on the Aggregator class itself. Example:
    #
    #   class Sum < Aggregator   # will give a method Aggregator.sum
    #     ...
    #   end
    #   Aggregator.sum{ size }
    #
    # All registered aggregators are available under `Aggregator.aggregators`
    # Those aggregators may also be iterated as follows:
    #
    #   Alf::Aggregator.each do |agg_class|
    #
    #     # agg_class is a subclass of Aggregator
    #
    #   end
    #
    class << self
      include Support::Registry

      # Automatically installs factory methods for inherited classes.
      #
      # @param [Class] clazz a class that extends Aggregator
      def inherited(clazz)
        register(clazz, Aggregator)
      end

      # Coerces `arg` to an Aggregator
      #
      # Implemented coercions are:
      # - Aggregator -> self
      # - String     -> through factory methods on self
      #
      # @param [Object] arg a value to coerce to an aggregator
      # @return [Aggregator] the coerced aggregator
      # @raise [ArgumentError] if the coercion fails
      def coerce(arg)
        case arg
        when Aggregator
          arg
        when String
          agg = instance_eval(arg)
          agg.source = arg
          agg
        else
          raise ArgumentError, "Invalid arg `arg` for Aggregator()"
        end
      end
    end # class << self

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
      options, block = {}, options if options.is_a?(Symbol) && block.nil?
      @options = default_options.merge(options)
      @functor = Support.coerce(block, TupleExpression)
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
    # @param [Support::TupleScope] a tuple scope bound to the current tuple
    # @return [Object] updated memo value
    def happens(memo, scope)
      raise unless Support::TupleScope===scope
      _happens(memo, @functor.evaluate(scope))
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
      scope = Support::TupleScope.new
      finalize(enum.inject(least){|m,t| happens(m, scope.__set_tuple(t))})
    end

    # Infers the resulting type from expression source code
    def infer_type
      Object
    end

    # Asserts that this aggregator knows its source code or raises a
    # NotImplementedError.
    #
    # @return [String] the source code when known
    def has_source_code!
      if source.nil?
        raise NotImplementedError, "No known source code for this aggregator"
      else
        source
      end
    end

    # Checks equality with another aggregator
    #
    # @param [Aggregator] other another aggregator
    # @return [Boolean] true is self and other are equal, false otherwise
    def ==(other)
      return false unless other.is_a?(Aggregator)
      has_source_code! == other.has_source_code!
    rescue NotImplementedError
      super
    end

    protected

      # @see happens.
      #
      # This method is intended to be overriden and returns _value_
      # by default, making this aggregator a "Last(...)" aggregator.
      def _happens(memo, value)
        value
      end

  end # class Aggregator
end # module Alf
require_relative 'aggregator/count'
require_relative 'aggregator/sum'
require_relative 'aggregator/min'
require_relative 'aggregator/max'
require_relative 'aggregator/avg'
require_relative 'aggregator/variance'
require_relative 'aggregator/stddev'
require_relative 'aggregator/collect'
require_relative 'aggregator/concat'
