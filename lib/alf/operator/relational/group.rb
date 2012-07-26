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

        def heading
          @heading ||= begin
            h = operand.heading.project(attributes, !allbut)
            h.merge(as => Relation)
          end
        end

        def keys
          @keys ||= operand.keys.map{|k|
            proj = k.project(attributes, !allbut)
            proj.empty? ? AttrList[as] : proj
          }.freeze
        end

      end # class Group
    end # module Relational
  end # module Operator
end # module Alf
