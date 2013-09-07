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
          keys, selectors = operand.keys, order.selectors
          if keys.any?{|k| k.subsetOf?(selectors) }
            keys + [ AttrList[as] ]
          else
            keys
          end
        end
      end

    end # class Rank
  end # module Algebra
end # module Alf
