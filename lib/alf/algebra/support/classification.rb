module Alf
  module Algebra
    module Classification

      # @return true if this is a relational operator, false otherwise
      def relational?
        ancestors.include?(Relational)
      end

      # @return true if this is an experimental operator, false otherwise
      def experimental?
        ancestors.include?(Experimental)
      end

      # @return true if this is a non relational operator, false otherwise
      def non_relational?
        ancestors.include?(NonRelational)
      end

      # @return true if this operator is a zero-ary operator, false otherwise
      def nullary?
        arity == 0
      end

      # @return true if this operator is an unary operator, false otherwise
      def unary?
        arity == 1
      end

      # @return true if this operator is a binary operator, false otherwise
      def binary?
        arity == 2
      end

    end # module Classification
  end # module Algebra
end # module Alf