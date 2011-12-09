module Alf
  module Operator
    # 
    # Specialization of Operator for operators that work on a unary input
    #
    module Unary
      include Operator 

      # Simply returns the first operand
      def operand
        operands.first
      end

    end # module Unary
  end # module Operator
end # module Alf
