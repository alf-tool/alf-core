module Alf
  module Engine
    #
    # Provides hash-based grouping.
    #
    class Group::Hash
      include Group
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] Attributes to group
      attr_reader :attributes

      # @return [AttrName] Name of the new attribute
      attr_reader :as

      # @return [Boolean] Group all but specified attributes?
      attr_reader :allbut

      # Creates a Group::Hash instance
      def initialize(operand, attributes, as, allbut, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @attributes = attributes
        @as = as
        @allbut = allbut
      end

      # (see Cog#each)
      def _each(&block)
        atr, alb = @attributes, @allbut
        index = Materialize::Hash.new(operand, atr, !alb, expr)
        index.each_pair do |k,v|
          grouped = Clip.new(v, atr, alb, expr).to_relation
          yield k.merge(@as => grouped)
        end
      end

    end # class Group::Hash
  end # module Engine
end # module Alf
