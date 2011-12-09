module Alf
  module Operator
    # 
    # Specialization of Operator for operators that work on a binary input
    #
    module Binary
      include Operator 

      # Returns the left operand
      def left
        operands.first
      end

      # Returns the right operand
      def right
        operands.last
      end

    end # module Binary
  end # module Operator
end # module Alf
