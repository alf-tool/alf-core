module Alf
  module Engine
    #
    # Take only a frame of the input relation according to an (offset, limit)
    # parameter.
    #
    # Example:
    #
    #   res = [
    #     {:name => "Jones", :price => 12.0, :id => 1},
    #     {:name => "Smith", :price => 10.0, :id => 2},
    #     {:name => "Blake", :price => 14.0, :id => 3}
    #     {:name => "Adams", :price => 13.0, :id => 4}
    #   ]
    #   Aggregate.new(res, 1, 2).to_a
    #   # => [
    #   #      {:name => "Smith", :price => 10.0, :id => 2},
    #   #      {:name => "Blake", :price => 14.0, :id => 3}
    #   #    ]
    #
    class Take
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Integer] The frame offset
      attr_reader :offset

      # @return [Integer] The frame limit
      attr_reader :limit

      # Creates a Take instance
      def initialize(operand, offset, limit, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @offset  = offset
        @limit   = limit
      end

      # (see Cog#each)
      def _each
        i = -1
        operand.each do |tuple|
          next   if (i += 1) < offset
          return if i >= offset+limit
          yield(tuple)
        end
      end

    end # class Take
  end # module Engine
end # module Alf
