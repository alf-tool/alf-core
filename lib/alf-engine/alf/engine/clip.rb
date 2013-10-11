module Alf
  module Engine
    #
    # Clips input tuples keeping (all but) specific attributes only.
    #
    # Example:
    #
    #     operand = [
    #       {:name => "Jones", :city => "London"}, 
    #       {:name => "Smith", :city => "Paris"}
    #     ]
    #     
    #     Clip.new(operand, AttrList[:name], false).to_a
    #     # => [
    #     #      {:name => "Jones"}, 
    #     #      {:name => "Smith"}
    #     #    ]
    #
    #     Clip.new(operand, AttrList[:name], true).to_a
    #     # => [
    #     #      {:city => "London"}, 
    #     #      {:city => "Paris"}
    #     #    ]
    #
    class Clip
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] List of attributes for clipping
      attr_reader :attributes

      # @return [Boolean] Clip *all but* attributes?
      attr_reader :allbut

      # Creates an Clip instance
      def initialize(operand, attributes, allbut, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @attributes = attributes
        @allbut = allbut
      end

      # (see Cog#each)
      def _each
        @operand.each do |tuple|
          yield @attributes.project_tuple(tuple, @allbut)
        end
      end

      def arguments
        [attributes]
      end

      def options
        {allbut: allbut}
      end

    end # class Clip
  end # module Engine
end # module Alf

