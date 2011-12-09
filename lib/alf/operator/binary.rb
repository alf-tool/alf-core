module Alf
  module Operator
    # 
    # Specialization of Operator for operators that work on a binary input
    #
    module Binary
      include Operator 

      # Create an operator instance
      def initialize(*args)
        signature.parse_args(args, self)
      end

      #
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = input
        self
      end

      protected

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
