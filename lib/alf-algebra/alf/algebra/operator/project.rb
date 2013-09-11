module Alf
  module Algebra
    class Project
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.option   :allbut,     Boolean,  false, 'Project all but specified attributes?'
      end

      def heading
        @heading ||= operand.heading.project(attributes, allbut)
      end

      def keys
        @keys ||= operand.keys.select{|k|
          k.project(attributes, allbut) == k
        }.if_empty{ Keys[ heading.to_attr_list ] }
      end

      def key_preserving?
        keys.any?{|k| operand.keys.include?(k) }
      end

      def stay_attributes
        allbut ? heading.to_attr_list : attributes
      end

    end # class Project
  end # module Algebra
end # module Alf
