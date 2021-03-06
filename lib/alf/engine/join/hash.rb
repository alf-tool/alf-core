module Alf
  module Engine
    #
    # Provides hash-based join.
    #
    class Join::Hash
      include Join
      include Cog

      # @return [Enumerable] The left operand
      attr_reader :left

      # @return [Enumerable] The right operand
      attr_reader :right

      # Creates a Join::Hash instance
      def initialize(left, right, expr = nil, compiler = nil)
        super(expr, compiler)
        @left = left
        @right = right
      end

      # Returns left and right operands in an array
      def operands
        [ left, right ]
      end

      # (see Cog#each)
      def _each(&block)
        index = nil
        left.each do |left_tuple|
          index ||= Materialize::Hash.new(right, lambda{|t|
            AttrList.new(left_tuple.keys & t.keys)
          }, false, expr).prepare
          index[left_tuple, true].each do |right_tuple|
            yield left_tuple.merge(right_tuple)
          end
        end
      end

    end # class Hash
  end # module Engine
end # module Alf
