module Alf
  module Operator
    #
    # Contains all methods for operator instances
    #
    module Base

      # Input datasets
      attr_accessor :datasets

      # @return [Environment] Environment to use (optional)
      attr_accessor :environment

      #
      # Sets the operator input
      #
      def pipe(input, env = environment)
        raise NotImplementedError, "Operator#pipe should be overriden"
      end

      # @return [Signature] the operator signature.
      def signature
        self.class.signature
      end

      # Yields each tuple in turn 
      def each(&block)
        compile.each(&block)
      end

      private :datasets=, :environment=
    end # module Base
    include Base
  end # module Operator
end # module Alf
