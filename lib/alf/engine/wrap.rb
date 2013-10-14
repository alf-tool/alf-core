module Alf
  module Engine
    #
    # Wraps attributes under as a sub-tuple
    #
    class Wrap
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] Attributes to wrap
      attr_reader :attributes

      # @return [AttrName] Name of the introduced wrapped attribute
      attr_reader :as

      # @return [Boolean] Allbut wrapping?
      attr_reader :allbut

      # Creates a SetAttr instance
      def initialize(operand, attributes, as, allbut, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @attributes = attributes
        @as = as
        @allbut = allbut
      end

      # (see Cog#each)
      def _each
        operand.each do |tuple|
          rest, key = @attributes.split_tuple(tuple, @allbut)
          key[@as] = rest
          yield key
        end
      end

      def arguments
        [ attribute ]
      end

    end # class Wrap
  end # module Engine
end # module Alf
