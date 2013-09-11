module Alf
  module Algebra
    #
    # Specialization of Operator for operators that work on a unary input
    #
    module Unary

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

      def with_operand(operand)
        with_operands(operand)
      end

      def compile
        operand.compile.to_compilable.compile(self)
      end

    end # module Unary
  end # module Algebra
end # module Alf
