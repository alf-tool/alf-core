module Alf
  module Algebra
    class Group
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.argument :as,         AttrName, :group
        s.option   :allbut,     Boolean,  false, 'Group all but specified attributes?'
      end

      def heading
        @heading ||= begin
          keep, sub = operand.heading.split(attributes, !allbut)
          keep.merge(as => Relation[sub])
        end
      end

      def keys
        @keys ||= operand.keys.map{|k|
          proj = k.project(attributes, !allbut)
          proj.empty? ? AttrList[as] : proj
        }.freeze
      end

    private

      def _type_check(options)
        no_unknown!(attributes - operand.attr_list)
        no_name_clash!(operand.attr_list - attributes, AttrList[as])
      end

    end # class Group
  end # module Algebra
end # module Alf
