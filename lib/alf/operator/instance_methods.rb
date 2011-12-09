module Alf
  module Operator
    #
    # Contains all methods for operator instances
    #
    module InstanceMethods

      # @param [Array] operands Operator operands
      attr_accessor :operands

      # Create an operator instance
      def initialize(*args)
        signature.parse_args(args, self)
      end

      # @return [Signature] the operator signature.
      def signature
        self.class.signature
      end

      # Yields each tuple in turn 
      def each(&block)
        compile.each(&block)
      end

    end # module InstanceMethods
    include InstanceMethods
  end # module Operator
end # module Alf