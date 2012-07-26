module Alf
  module Operator
    module Relational
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
          @keys ||= operand.keys.
                            project(attributes, allbut).
                            compact.
                            if_empty{ Keys[ heading.to_attr_list ] }
        end

      end # class Project
    end # module Relational
  end # module Operator
end # module Alf
