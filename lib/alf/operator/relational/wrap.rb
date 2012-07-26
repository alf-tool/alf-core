module Alf
  module Operator
    module Relational
      class Wrap
        include Operator, Relational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.argument :as, AttrName, :wrapped
          s.option   :allbut, Boolean,  false, 'Wrap all but specified attributes?'
        end

        def heading
          @heading ||= stay_heading.merge(as => Hash)
        end

        def keys
          @keys ||= operand.keys.map{|k|
            rest = k.project(attributes, !allbut)
            (rest == k) ? rest : (rest | [ as ])
          }
        end

        def wrapped_heading
          @wrapped_heading ||= operand.heading.project(attributes, allbut)
        end

        def wrapped_attrs
          @wrapped_attrs ||= wrapped_heading.to_attr_list
        end

        def stay_heading
          @stay_heading ||= operand.heading.project(attributes, !allbut)
        end

        def stay_attrs
          @stay_attrs ||= wrapped_heading.to_attr_list
        end

      end # class Wrap
    end # module Relational
  end # module Operator
end # module Alf
