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

      end # class Project
    end # module Relational
  end # module Operator
end # module Alf
