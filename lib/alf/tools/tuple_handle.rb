module Alf
  module Tools
    #
    # Provides a handle for implementing a flyweight design pattern on tuples.
    #
    # This class works hand-in-hand with TupleExpression as it provides a scope
    # for their evaluation on tuples.
    #
    # Example:
    #
    #   handle = TupleHandle.new
    #   expr   = TupleExpression["status > 10"]
    #   relation.each do |tuple|
    #     expr.evaluate(handle.set(tuple))
    #   end
    #
    class TupleHandle < BasicObject

      # Creates a handle instance
      def initialize
        @tuple = nil
      end

      # Returns true if the decorated tuple has `name` as key.
      def respond_to?(name)
        @tuple && @tuple.has_key?(name)
      end

      # Sets the next tuple to use.
      #
      # On first call, this method installs the handle as a side effect.
      #
      # @param [Tuple] tuple the current iterated tuple
      # @return [TupleHandle] self
      def set(tuple)
        _build(tuple) if @tuple.nil?
        @tuple = tuple
        self
      end

      # Evaluates a tuple expression on the current tuple.
      #
      # @param [Object] expr a tuple expression (coercions apply)
      # @return [Object] the result of evaluting `expr` on self
      def evaluate(expr = nil, &bl)
        TupleExpression.coerce(expr || bl).evaluate(self)
      end

      private

        # Builds this handle with a tuple.
        #
        # This method should be called only once and installs instance methods on
        # the handle with keys of _tuple_.
        def _build(tuple)
          tuple.keys.each do |k|
            (class << self; self; end).send(:define_method, k) do
              @tuple[k]
            end
          end
        end

    end # class TupleHandle
  end # module Tools
end # module Alf
