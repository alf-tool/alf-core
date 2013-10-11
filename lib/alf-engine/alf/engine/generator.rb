module Alf
  module Engine
    #
    # Generates tuples with an integer attributes, with an initial offset and
    # a step.
    #
    # Example:
    #
    #     Generator.new(3, :id, 10, 5).to_a
    #     # => [
    #     #      {:id => 10},
    #     #      {:id => 15},
    #     #      {:id => 20}
    #     #    ]
    #
    class Generator
      include Cog

      # @return [Symbol] Name of the autonum attribute
      attr_reader :as

      # @return [Integer] Initial offset
      attr_reader :offset

      # @return [Integer] Generation step
      attr_reader :step

      # @return [Integer] Count number of tuples to generate
      attr_reader :count

      # Creates an Generator instance
      def initialize(as, offset, step, count, expr = nil, compiler = nil)
        super(expr, compiler)
        @as = as
        @offset = offset
        @step = step
        @count = count
      end

      # (see Cog#each)
      def _each
        cur = offset
        count.times do |i|
          yield(@as => cur)
          cur += step
        end
      end

      def arguments
        [ offset, step, count ]
      end

    end # class Generator
  end # module Engine
end # module Alf

