module Alf
  module Operator
    #
    # Specialization of Operator for operators that work on a unary input
    #
    module Unary
      include Operator

      # Class-level methods
      module ClassMethods

        # (see Operator::ClassMethods#arity)
        def arity
          1
        end

      end # module ClassMethods

      def self.included(mod)
        super
        mod.extend(ClassMethods)
      end

      # Simply returns the first operand
      def operand
        operands.first
      end

    end # module Unary
  end # module Operator
end # module Alf
