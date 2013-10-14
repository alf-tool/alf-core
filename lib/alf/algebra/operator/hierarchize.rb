module Alf
  module Algebra
    class Hierarchize
      include Operator, Relational, Unary, Experimental

      signature do |s|
        s.argument :id,     AttrList, [:id]
        s.argument :parent, AttrList, [:parent]
        s.argument :as,     AttrName, [:children]
      end

      def heading
        @heading ||= Relation.type(operand.heading){|r| {as => r}}.heading
      end

      def keys
        operand.keys
      end

    private

      def _type_check(options)
        no_unknown!(id - operand.attr_list)
        no_unknown!(parent - operand.attr_list)
        no_name_clash!(operand.attr_list, AttrList[as])
      end

    end # class Hierarchize
  end # module Algebra
end # module Alf
