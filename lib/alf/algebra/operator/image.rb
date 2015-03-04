module Alf
  module Algebra
    class Image
      include Operator
      include Relational
      include Binary

      signature do |s|
        s.argument :as, AttrName, []
      end

      def heading
        @heading ||= left.heading + Heading.coerce(as => group_type)
      end

      def keys
        left.keys
      end

    private

      def common_attrs
        left.attr_list & right.attr_list
      end

      def group_type
        @group_type ||= Relation[right.heading.allbut(common_attrs)]
      end

      def _type_check(options)
        joinable_headings!(left.heading, right.heading, options)
        no_name_clash!(left.attr_list, AttrList[as])
      end

    end # class Image
  end # module Algebra
end # module Alf
