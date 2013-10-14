module Alf
  module Algebra
    class Compact
      include Operator
      include NonRelational
      include Unary

      signature do |s|
      end

      def heading
        @heading ||= operand.heading
      end

      def keys
        @keys ||= operand.keys.if_empty{ Keys[ heading.to_attr_list ] }
      end

    private

      def _type_check(options)
      end

    end # class Compact
  end # module Algebra
end # module Alf
