module Alf
  module Engine
    #
    # Replace missing attributes and nil by default, computed values.
    #
    # Example:
    #
    #     rel = [
    #       {:id => 1, :name => "Jones"},
    #       {:id => 2, :name => nil}
    #     ]
    #     Defaults.new(rel, TupleComputation[:name => "Smith"]).to_a
    #     # => [
    #     #      {:id => 1, :name => "Jones"},
    #     #      {:id => 2, :name => "Smith"}
    #     #    ]
    #
    class Defaults < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [TupleComputation] The default values
      attr_reader :defaults

      # Creates a Defaults instance
      def initialize(operand, defaults)
        @operand = operand
        @defaults = defaults
      end

      # (see Cog#each)
      def each
        scope = Tools::TupleScope.new
        operand.each do |tuple|
          defs = @defaults.evaluate(scope.__set_tuple(tuple))
          yield tuple.merge(defs){|k,v1,v2| (v1.nil? ? v2 : v1)}
        end
      end

    end # class Defaults
  end # module Engine
end # module Alf
