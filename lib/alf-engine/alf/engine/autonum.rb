module Alf
  module Engine
    #
    # Autonumbers input tuples under a new `as` attribute. Autonumbering starts
    # at 0.
    #
    # Example:
    #
    #     operand = [
    #       {:name => "Jones"}, 
    #       {:name => "Smith"}
    #     ]
    #     Autonum.new(operand, :id).to_a
    #     # => [
    #     #      {:name => "Jones", :id => 0}, 
    #     #      {:name => "Smith", :id => 1}
    #     #    ]
    #
    class Autonum
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Symbol] Name of the autonum attribute
      attr_reader :as

      # Creates an Autonum instance
      def initialize(operand, as)
        @operand = operand
        @as = as
      end

      # (see Cog#each)
      def _each
        autonum = 0
        @operand.each do |tuple|
          yield tuple.merge(@as => autonum)
          autonum += 1
        end
      end

    end # class Autonum
  end # module Engine
end # module Alf

