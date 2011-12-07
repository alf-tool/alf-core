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
    class Generator < Cog

      # @return [Integer] Number of tuples to generate
      attr_reader :number

      # @return [Symbol] Name of the autonum attribute
      attr_reader :as

      # @return [Integer] Initial offset
      attr_reader :offset

      # @return [Integer] Generation step
      attr_reader :step

      # Creates an Generator instance
      def initialize(number, as, offset = 0, step = 1)
        @number = number
        @as = as
        @offset = offset
        @step = step
      end

      # (see Cog#each)
      def each
        cur = offset
        number.times do |i|
          yield(@as => cur)
          cur += step
        end
      end

    end # class Generator
  end # module Engine
end # module Alf

