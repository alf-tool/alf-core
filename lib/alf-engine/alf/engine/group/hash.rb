module Alf
  module Engine
    #
    # Provides hash-based grouping.
    #
    class Group::Hash < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] Attributes to group
      attr_reader :attributes

      # @return [AttrName] Name of the new attribute
      attr_reader :as

      # @return [Boolean] Group all but specified attributes?
      attr_reader :allbut

      # Creates a Hash instance
      def initialize(operand, attributes, as, allbut)
        @operand = operand
        @attributes = attributes
        @as = as
        @allbut = allbut
      end

      # (see Cog#each)
      def each(&block)
        atr, alb = @attributes, @allbut
        index = Materialize::Hash.new(operand, atr, !alb)
        index.each_pair do |k,v|
          grouped = Relation.new(Clip.new(v, atr, alb).to_set)
          yield k.merge(@as => grouped)
        end
      end

    end # class Hash
  end # module Engine
end # module Alf
