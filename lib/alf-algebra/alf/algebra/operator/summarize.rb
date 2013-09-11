module Alf
  module Algebra
    class Summarize
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :by,            AttrList, []
        s.argument :summarization, Summarization, {}
        s.option   :allbut,        Boolean, false, "Summarize on all but specified attributes?"
      end

      def heading
        @heading ||= begin
          op_h = operand.heading.project(by, allbut)
          op_h.merge(summarization.to_heading)
        end
      end

      def keys
        @keys ||= begin
          attrs = operand.heading.to_attr_list.project(by, allbut)
          operand.keys.select{|k| k.subset?(attrs) }.if_empty{ Keys[ attrs ] }
        end
      end

    end # class Summarize
  end # module Algebra
end # module Alf
