module Alf
  module Operator
    module NonRelational
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

        def key_preserving?
          !(operand.keys & keys).empty?
        end

      end # class Clip
    end # module NonRelational
  end # module Operator
end # module Alf
