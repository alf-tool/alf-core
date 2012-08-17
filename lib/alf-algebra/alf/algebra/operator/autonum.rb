module Alf
  module Algebra
    class Autonum
      include Operator, NonRelational, Unary

      signature do |s|
        s.argument :as, AttrName, :autonum
      end

      def heading
        @heading ||= operand.heading + Heading[as => Integer]
      end

      def keys
        @keys ||= operand.keys + [ [ as ] ]
      end

    end # class Autonum
  end # module Algebra
end # module Alf
