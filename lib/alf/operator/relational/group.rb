module Alf
  module Operator
    module Relational
      class Group
        include Operator, Relational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.argument :as,         AttrName, :group
          s.option   :allbut,     Boolean,  false, 'Group all but specified attributes?'
        end

      end # class Group
    end # module Relational
  end # module Operator
end # module Alf
