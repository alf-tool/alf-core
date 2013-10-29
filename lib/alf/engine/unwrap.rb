module Alf
  module Engine
    #
    # Unwraps a tuple attribute
    #
    class Unwrap
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrName] Name of the attribute to unwrap
      attr_reader :attribute

      # Creates a SetAttr instance
      def initialize(operand, attribute, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @attribute = attribute
      end

      # (see Cog#each)
      def _each
        operand.each do |tuple|
          tuple   = tuple.dup
          tuple   = tuple.to_hash unless tuple.is_a?(Hash)
          wrapped = tuple.delete(@attribute) || {}
          wrapped = symbolize(wrapped)
          tuple.merge!(wrapped)
          yield tuple
        end
      end

      def arguments
        [ attribute ]
      end

    end # class Unwrap
  end # module Engine
end # module Alf
