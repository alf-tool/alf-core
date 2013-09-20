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

    end # class Hierarchize
  end # module Algebra
end # module Alf
