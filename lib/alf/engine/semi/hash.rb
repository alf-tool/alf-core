module Alf
  module Engine
    #
    # Filters tuples from `left` that match or do not match tuples from `right`.
    #
    class Semi::Hash
      include Semi
      include Cog

      # @return [Enumerable] The left operand
      attr_reader :left

      # @return [Enumerable] The right operand
      attr_reader :right

      # @return [Boolean] Match (true) or not match (false)?
      attr_reader :predicate

      # Creates a Semi::Hash instance
      def initialize(left, right, predicate, expr = nil, compiler = nil)
        super(expr, compiler)
        @left = left
        @right = right
        @predicate = predicate
      end

      # Returns left and right operands in an array
      def operands
        [ left, right ]
      end

      # (see Cog#each)
      def _each
        index = nil
        left.each do |left_tuple|
          index ||= build_index(left_tuple, right)
          yield left_tuple if index[left_tuple, true] == predicate
        end
      end

      def arguments
        [ predicate ]
      end

    private

      def build_index(left_witness, right)
        index = Materialize::Hash.new(right)
        index.key = ->(t){
          AttrList.new(left_witness.keys & t.keys)
        }
        index.neutral = ->(t){
          false
        }
        index.accumulate = ->(_,c,_){
          true
        }
        index.prepare
      end

    end # class Semi::Hash
  end # module Engine
end # module Alf
