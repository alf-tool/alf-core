module Alf
  module Algebra
    class TypeCheck
      include Operator, NonRelational, Unary

      signature do |s|
        s.argument :type_check_heading, Heading
        s.option   :strict, Boolean,  false, 'Be strict, not allowing tuple projections?'
      end

      def heading
        type_check_heading
      end

      def keys
        operand.keys
      end

    end # class TypeCheck
  end # module Algebra
end # module Alf
