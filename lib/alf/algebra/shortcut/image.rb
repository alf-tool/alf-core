module Alf
  module Algebra
    class Image
      include Shortcut
      include Binary

      signature do |s|
        s.argument :name, AttrName, []
      end

      def keys
        left.keys
      end

      def expand
        grouped = join(left, group(right, common_attrs, name, allbut: true))
        missing = extend(not_matching(left, right), name => group_type.empty)
        union(grouped, missing)
      end

    private

      def common_attrs
        left.attr_list & right.attr_list
      end

      def group_type
        @group_type ||= Relation[right.heading.allbut(common_attrs)]
      end

    end # class Image
  end # module Algebra
end # module Alf
