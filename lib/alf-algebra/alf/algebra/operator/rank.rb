module Alf
  module Algebra
    class Rank
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :order, Ordering, []
        s.argument :as, AttrName, :rank
      end

      def heading
        @heading ||= operand.heading.merge(as => Integer)
      end

      def keys
        @keys ||= begin
          keys, selectors = operand.keys, order.to_attr_list
          if keys.any?{|k| k.subset_of?(selectors) }
            keys + [ AttrList[as] ]
          else
            keys
          end
        end
      end

    private

      def _type_check(options)
        valid_ordering!(order, operand.attr_list)
        no_name_clash!(operand.attr_list, AttrList[as])
      end

    end # class Rank
  end # module Algebra
end # module Alf
