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
          @heading ||= begin
            h = operand.heading.project(attributes, !allbut)
            h.merge(as => Hash)
          end
        end

      end # class Wrap
    end # module Relational
  end # module Operator
end # module Alf
