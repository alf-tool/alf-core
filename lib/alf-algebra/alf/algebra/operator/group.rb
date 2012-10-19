module Alf
  module Algebra
    class Group
      include Operator, Relational, Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.argument :as,         AttrName, :group
        s.option   :allbut,     Boolean,  false, 'Group all but specified attributes?'
      end

      def heading
        @heading ||= begin
          keep, sub = operand.heading.split(attributes, !allbut)
          keep.merge(as => Relation.type(sub))
        end
      end

      def keys
        @keys ||= operand.keys.map{|k|
          proj = k.project(attributes, !allbut)
          proj.empty? ? AttrList[as] : proj
        }.freeze
      end

    end # class Group
  end # module Algebra
end # module Alf
