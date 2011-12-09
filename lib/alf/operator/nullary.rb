module Alf
  module Operator
    # 
    # Specialization of Operator for operators without operands
    #
    module Nullary
      include Operator 
      
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
