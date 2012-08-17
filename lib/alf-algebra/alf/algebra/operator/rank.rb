module Alf
  module Algebra
    class Rank
      include Operator, Relational, Unary

      signature do |s|
        s.argument :order, Ordering, []
        s.argument :as, AttrName, :rank
      end

      def heading
        @heading ||= operand.heading.merge(as => Integer)
      end

      def keys
        @keys ||= begin
          keys, order_attrs = operand.keys, order.to_attr_list
          if keys.any?{|k| order_attrs.superset?(k)}
            keys + [ AttrList[as] ]
          else
            keys
          end
        end
      end

    end # class Rank
  end # module Algebra
end # module Alf
