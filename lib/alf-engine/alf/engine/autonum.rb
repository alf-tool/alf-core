module Alf
  module Engine
    class Autonum < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Symbol] Name of the autonum attribute
      attr_reader :as

      # Creates an Autonum instance
      def initialize(operand, as)
        @operand = operand
        @as = as
      end

      # (see Iterator#each)
      def each
        autonum = 0
        @operand.each do |tuple|
          yield tuple.merge(@as => autonum)
          autonum += 1
        end
      end

    end # class Autonum
  end # module Engine
end # module Alf

