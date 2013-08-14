module Alf
  module Algebra
    class Page
      include Operator, Relational, Unary

      signature do |s|
        s.argument :ordering, Ordering, []
        s.argument :page_index, Integer, 1
        s.option   :page_size,  Integer, 30, 'Size of the pages to compute'
      end

      def heading
        operand.heading
      end

      def keys
        operand.keys
      end

      def full_ordering
        attrlist = ordering.to_attr_list
        if keys.any?{|key| key.subset?(attrlist) }
          ordering
        elsif key = keys.first
          ordering.merge(key.to_ordering){|a,d1,d2| d1 }
        else
          ordering.merge(heading.to_attr_list.to_ordering){|a,d1,d2| d1 }
        end
      end

      def offset
        (page_index - 1) * page_size
      end

    end # class Page
  end # module Algebra
end # module Alf
