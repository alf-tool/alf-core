module Alf
  module Algebra
    class Sort
      include Operator, NonRelational, Unary

      signature do |s|
        s.argument :ordering, Ordering, []
      end

      def heading
        @heading ||= operand.heading
      end

      def keys
        @keys ||= operand.keys
      end

    end # class Sort
  end # module Algebra
end # module Alf
