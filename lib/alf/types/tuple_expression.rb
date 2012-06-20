module Alf
  module Types
    #
    # A tuple expression is a Ruby expression whose evaluates in the scope of a
    # specific tuple handle.
    #
    # Example:
    #   expr = TupleExpression["status * 10"]
    #   expr.call(:status => 20)
    #   # => 200
    #
    class TupleExpression

      # @return [Proc] the lambda expression
      attr_reader :expr_lambda

      # @return [String] the expression source code (may be nil)
      attr_reader :source

      # Creates a tuple expression from a Proc object
      #
      # @param [Proc] expr a Proc for the expression
      # @param [String] source the source code of the expression (optional)
      def initialize(expr, source = nil)
        @expr_lambda = expr
        @source = source
      end

      class << self

        # Coerces `arg` to a tuple expression.
        #
        # Implemented coercions are:
        # - TupleExpression -> self
        # - Proc            -> TupleExpression.new(arg, nil)
        # - String          -> TupleExpression.new(..., arg)
        # - Symbol          -> TupleExpression.new(..., arg)
        #
        # @param [Object] arg a value to convert to a tuple expression
        # @return [TupleExpression] the expression if coercion succeeds
        # @raise [ArgumentError] if the coercion fails
        def coerce(arg)
          case arg
          when TupleExpression
            arg
          when Proc
            TupleExpression.new(arg, nil)
          when String, Symbol
            TupleExpression.new(eval("lambda{ #{arg} }"), arg)
          else
            raise ArgumentError, "Invalid argument `#{arg}` for TupleExpression()"
          end
        end
        alias :[] :coerce

        # Convert commandline arguments to a tuple expression
        #
        # Arguments should either be empty or a singleton. In the former case,
        # `opts[:default]` is used. In the latter case, the unique argument is
        # taken as the expression source code and `coerce` is called on it.
        #
        # @param [Array] args commandline arguments
        # @param [Hash] opts coercion options.
        # @return [TupleExpression] the expression if coercion succeeds
        # @raise [ArgumentError] if the coercion fails.
        def from_argv(argv, opts = {})
          raise ArgumentError if argv.size > 1
          coerce(argv.first || opts[:default])
        end

      end # class << self

      # Evaluates the expression in the context of a TupleHandle
      #
      # @param [TupleHandle] handle a tuple handle instance.
      # @return [Object] the result of evaluating the expression in the context
      #         of `handle`
      def evaluate(handle = nil)
        if RUBY_VERSION < "1.9"
          handle.instance_eval(&@expr_lambda)
        else
          handle.instance_exec(&@expr_lambda)
        end
      end

      # Evaluates the expression on a tuple
      #
      # This is a convenient method for the following, longer expression:
      #
      #     evaluate(TupleHandle.new.set(tuple))
      #
      # Note, however, using a Handle as in the example above is much more
      # efficient when evaluating the same expression on multiple tuples
      # in sequence.
      #
      # @param [Hash] tuple a Tuple instance
      # @return [Object] the result of evaluating the expression on `tuple`
      def call(tuple)
        evaluate(Tools::TupleHandle.new.set(tuple))
      end
      alias :[] :call

      # Returns a hash code.
      #
      # @return [Integer] a hash code for this expression
      def hash
        @source.nil? ? @expr_lambda.hash : @source.hash
      end

      # Checks equality with another expression
      #
      # @param [TupleExpression] another expression.
      # @return [Boolean] true if self and other are equal, false otherwise
      def ==(other)
        return false unless other.is_a?(TupleExpression)
        if source.nil? || other.source.nil?
          expr_lambda == other.expr_lambda
        else
          source == other.source
        end
      end
      alias :eql? :==

      # Returns a ruby literal for this expression.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::#{Tools.class_name(self.class)}[#{Tools.to_ruby_literal(has_source_code!)}]"
      end

      # Returns a string representation of this expression
      def inspect
        to_ruby_literal
      rescue NotImplementedError
        super
      end

      # Asserts that this expression knows its source code or raises a
      # NotImplementedError.
      #
      # @return [String] the source code when known
      def has_source_code!
        if source.nil?
          raise NotImplementedError, "No known source code for this expression"
        else
          source
        end
      end

    end # class TupleExpression
  end # module Types
end # module Alf
