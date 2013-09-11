module Alf
  module Algebra
    class Unwrap
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :attribute, AttrName, :wrapped
      end

      def heading
        @heading ||= begin
          op_h = operand.heading
          op_h.allbut([attribute]).merge(op_h[attribute].heading)
        end
      end

      def keys
        operand.keys
      end

    end # class Unwrap
  end # module Algebra
end # module Alf
