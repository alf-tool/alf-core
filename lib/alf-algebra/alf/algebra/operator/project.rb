module Alf
  module Algebra
    class Project
      include Operator, Relational, Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.option   :allbut,     Boolean,  false, 'Project all but specified attributes?'
      end

      def heading
        @heading ||= operand.heading.project(attributes, allbut)
      end

      def keys
        @keys ||= begin
          keys = operand.keys.project(attributes, allbut).compact
          if keys.empty?
            has_empty = operand.keys.include?(AttrList::EMPTY)
            keys = Keys[ has_empty ? AttrList::EMPTY : heading.to_attr_list ]
          end
          keys
        end
      end

      def key_preserving?
        keys.any?{|k| operand.keys.any?{|op_k| k.subset?(op_k) } }
      end

      def stay_attributes
        allbut ? heading.to_attr_list : attributes
      end

    end # class Project
  end # module Algebra
end # module Alf
