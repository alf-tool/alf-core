module Alf
  module Algebra
    class Page
      include Operator
      include Relational
      include Unary
      include WithOrdering

      signature do |s|
        s.argument :ordering, Ordering, []
        s.argument :page_index, Integer, 1
        s.option   :page_size,  Integer, 25, 'Size of the pages to compute'
      end

      def heading
        operand.heading
      end

      def keys
        operand.keys
      end

    end # class Page
  end # module Algebra
end # module Alf
