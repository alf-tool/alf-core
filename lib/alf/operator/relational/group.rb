module Alf
  module Operator
    module Relational
      class Group
        include Relational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.argument :as,         AttrName, :group
          s.option   :allbut,     Boolean,  false, 'Group all but specified attributes?'
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Group::Hash.new(operand, attributes, as, allbut, context)
        end
  
      end # class Group
    end # module Relational
  end # module Operator
end # module Alf
