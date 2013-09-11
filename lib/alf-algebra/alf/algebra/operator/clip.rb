module Alf
  module Algebra
    class Clip
      include Operator
      include NonRelational
      include Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.option   :allbut,     Boolean, false, "Apply an allbut clipping?"
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

    end # class Clip
  end # module Algebra
end # module Alf
