module Alf
  module Engine
    #
    # Filters tuples from `left` that match or do not match tuples from `right`.
    #
    class Semi::Hash
      include Cog

      # @return [Enumerable] The left operand
      attr_reader :left

      # @return [Enumerable] The right operand
      attr_reader :right

      # @return [Boolean] Match (true) or not match (false)?
      attr_reader :predicate

      # Creates a Semi::Hash instance
      def initialize(left, right, predicate)
        @left = left
        @right = right
        @predicate = predicate
      end

      # (see Cog#each)
      def each
        index = nil
        left.each do |left_tuple|
          index ||= Materialize::Hash.new(right, lambda{|t|
            AttrList.new(left_tuple.keys & t.keys)
          }, false).prepare
          if index[left_tuple, true].empty? != predicate
            yield left_tuple 
          end
        end
      end

    end # class Semi::Hash
  end # module Engine
end # module Alf
