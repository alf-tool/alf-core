module Alf
  module Engine
    #
    # Provides hash-based join.
    #
    class Join::Hash < Cog

      # @return [Enumerable] The left operand
      attr_reader :left

      # @return [Enumerable] The right operand
      attr_reader :right

      # Creates a Join::Hash instance
      def initialize(left, right, context=nil)
        super(context)
        @left = left
        @right = right
      end

      # (see Cog#each)
      def each(&block)
        index = nil
        left.each do |left_tuple|
          index ||= Materialize::Hash.new(right, lambda{|t|
            AttrList.new(left_tuple.keys & t.keys)
          }, false, context).prepare
          index[left_tuple, true].each do |right_tuple|
            yield left_tuple.merge(right_tuple)
          end
        end
      end

    end # class Hash
  end # module Engine
end # module Alf
