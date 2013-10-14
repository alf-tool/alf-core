module Alf
  module Algebra
    class Quota
      include Operator
      include Relational
      include Unary
      include Experimental

      signature do |s|
        s.argument :by,            AttrList, []
        s.argument :order,         Ordering, []
        s.argument :summarization, Summarization, {}
      end

      def heading
        @heading ||= operand.heading.merge(summarization.to_heading)
      end

      def keys
        @keys ||= operand.keys
      end

    private

      def _type_check(options)
        no_unknown!(by - operand.attr_list)
        valid_ordering!(order, operand.attr_list)
        no_name_clash!(operand.attr_list, summarization.to_attr_list)
      end

    end # class Quota
  end # module Algebra
end # module Alf
