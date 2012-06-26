module Alf
  module Operator
    #
    # Specialization of Operator for operators that work on a binary input
    #
    module Binary

      # Class-level methods
      module ClassMethods

        # (see Operator::ClassMethods#arity)
        def arity
          2
        end

      end # module ClassMethods

      def self.included(mod)
        super
        mod.extend(ClassMethods)
      end

      # Returns the left operand
      def left
        operands.first
      end

      # Returns the right operand
      def right
        operands.last
      end

    end # module Binary
  end # module Operator
end # module Alf
