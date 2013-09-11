module Alf
  module Algebra
    class Coerce
      include Operator
      include NonRelational
      include Unary

      signature do |s|
        s.argument :coercions, Heading, {}
      end

      def heading
        @heading ||= operand.heading.merge(coercions)
      end

      def keys
        @keys ||= operand.keys
      end

    end # class Coerce
  end # module Algebra
end # module Alf
