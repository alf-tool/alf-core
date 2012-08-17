module Alf
  module Algebra
    class Compact
      include Operator, NonRelational, Unary

      signature do |s|
      end

      def heading
        @heading ||= operand.heading
      end

      def keys
        @keys ||= operand.keys.if_empty{ Keys[ heading.to_attr_list ] }
      end

    end # class Compact
  end # module Algebra
end # module Alf
