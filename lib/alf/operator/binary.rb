module Alf
  module Operator
    # 
    # Specialization of Operator for operators that work on a binary input
    #
    module Binary
      include Operator 
      
      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = input
        self
      end

      protected
      
      def command_line_operands(operands)
        (operands.size < 2) ? ([$stdin] + operands) : operands
      end
    
      # Returns the left operand
      def left
        Iterator.coerce(datasets.first, environment)
      end
      
      # Returns the right operand
      def right
        Iterator.coerce(datasets.last, environment)
      end
      
    end # module Binary
  end # module Operator
end # module Alf
