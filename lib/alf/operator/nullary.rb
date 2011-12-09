module Alf
  module Operator
    # 
    # Specialization of Operator for operators without operands
    #
    module Nullary
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
        self.datasets = []
        self
      end

    end # module Nullary
  end # module Operator
end # module Alf
