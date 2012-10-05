module Alf
  module Engine
    class Ungroup
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrName] Relation-valued attribute to ungroup
      attr_reader :attribute

      # Creates a Ungroup instance
      def initialize(operand, attribute)
        @operand = operand
        @attribute = attribute
      end

      # (see Cog#each)
      def each
        operand.each do |tuple|
          tuple = tuple.dup
          tuple.delete(@attribute).each do |subtuple|
            yield tuple.merge(subtuple)
          end
        end
      end

    end # class Ungroup
  end # module Engine
end # module Alf
