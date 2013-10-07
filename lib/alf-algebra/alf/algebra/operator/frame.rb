module Alf
  module Algebra
    class Frame
      include Operator
      include Relational
      include Unary
      include WithOrdering

      signature do |s|
        s.argument :ordering, Ordering, []
        s.argument :offset,   Integer, 0
        s.argument :limit,    Integer, 25
      end

      def heading
        operand.heading
      end

      def keys
        operand.keys
      end

    private

      def _type_check(options)
        valid_ordering!(ordering, operand.attr_list)
        type_check_error!("invalid offset `#{offset}`") unless offset >= 0
        type_check_error!("invalid limit `#{limit}`")   unless limit >= 0
      end

    end # class Frame
  end # module Algebra
end # module Alf
