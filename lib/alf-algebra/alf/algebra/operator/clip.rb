module Alf
  module Algebra
    class Clip
      include Operator, NonRelational, Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.option   :allbut,     Boolean, false, "Apply an allbut clipping?"
      end

      def heading
        @heading ||= operand.heading.project(attributes, allbut)
      end

      def keys
        @keys ||= operand.keys.
                          project(attributes, allbut).
                          compact.
                          if_empty{ Keys[ heading.to_attr_list ] }
      end

      def stay_attributes
        allbut ? heading.to_attr_list : attributes
      end

    end # class Clip
  end # module Algebra
end # module Alf
