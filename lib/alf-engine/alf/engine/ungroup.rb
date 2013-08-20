module Alf
  module Engine
    class Ungroup
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrName] Relation-valued attribute to ungroup
      attr_reader :attribute

      # Creates a Ungroup instance
      def initialize(operand, attribute, expr = nil)
        super(expr)
        @operand = operand
        @attribute = attribute
      end

      # (see Cog#each)
      def _each
        operand.each do |tuple|
          tuple = tuple.dup
          tuple = tuple.to_hash unless tuple.is_a?(Hash)
          tuple.delete(@attribute).each do |subtuple|
            yield tuple.merge(subtuple)
          end
        end
      end

    end # class Ungroup
  end # module Engine
end # module Alf
