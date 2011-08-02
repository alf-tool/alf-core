module Alf
  module Operator
    # 
    # Specialization of Operator for operators that work on a unary input
    #
    module Unary
      include Operator 
      
      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = [ input ]
        self
      end

      protected
    
      #
      # Simply returns the first dataset
      #
      def input
        Iterator.coerce(datasets.first, environment)
      end
      
      # 
      # Yields the block with each input tuple.
      #
      # This method should be preferred to <code>input.each</code> when possible.
      #
      def each_input_tuple
        input.each(&Proc.new)
      end
      
    end # module Unary
  end # module Operator
end # module Alf
