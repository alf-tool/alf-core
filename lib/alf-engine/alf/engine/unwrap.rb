module Alf
  module Engine
    #
    # Unwraps a tuple attribute
    #
    class Unwrap < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrName] Name of the attribute to unwrap
      attr_reader :attribute

      # Creates a SetAttr instance
      def initialize(operand, attribute)
        @operand = operand
        @attribute = attribute
      end

      # (see Cog#each)
      def each
        operand.each do |tuple|
          tuple = tuple.dup
          tuple.merge!(tuple.delete(@attribute) || {})
          yield tuple
        end
      end

    end # class Unwrap
  end # module Engine
end # module Alf
