module Alf
  module Algebra
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

      def with_left(left)
        with_operands(left, right)
      end

      def with_right(right)
        with_operands(left, right)
      end

      def common_heading
        @common_heading ||= (left.heading & right.heading)
      end

      def common_attributes
        @common_attributes ||= common_heading.to_attr_list
      end

      def compile
        left.compile.to_compilable.compile(self)
      end

    end # module Binary
  end # module Algebra
end # module Alf
