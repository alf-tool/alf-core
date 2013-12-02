module Alf
  module Engine
    class Ungroup
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrName] Relation-valued attribute to ungroup
      attr_reader :attribute

      # Creates a Ungroup instance
      def initialize(operand, attribute, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @attribute = attribute
      end

      # (see Cog#each)
      def _each
        operand.each do |tuple|
          tuple = tuple.dup
          tuple = tuple.to_hash unless tuple.is_a?(Hash)
          unless rva = tuple.delete(@attribute)
            raise "No such RVA `#{@attribute}` on #{tuple.inspect}"
          end
          rva.each do |subtuple|
            subtuple = symbolize(subtuple)
            yield tuple.merge(subtuple)
          end
        end
      end

      def arguments
        [ attribute ]
      end

    end # class Ungroup
  end # module Engine
end # module Alf
