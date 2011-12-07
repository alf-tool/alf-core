module Alf
  module Engine
    #
    # Generates `number` tuples.
    #
    # Example:
    #
    #     Generator.new(2, :id).to_a
    #     # => [
    #     #      {:id => 0}, 
    #     #      {:id => 1}
    #     #    ]
    #
    class Generator < Cog

      # @return [Integer] Number of tuples to generate
      attr_reader :number

      # @return [Symbol] Name of the autonum attribute
      attr_reader :as

      # Creates an Generator instance
      def initialize(number, as)
        @number = number
        @as = as
      end

      # (see Cog#each)
      def each
        number.times do |i|
          yield(@as => i)
        end
      end

    end # class Generator
  end # module Engine
end # module Alf

