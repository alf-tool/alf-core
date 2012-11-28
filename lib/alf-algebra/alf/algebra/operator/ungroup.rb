module Alf
  module Algebra
    class Ungroup
      include Operator, Relational, Unary

      signature do |s|
        s.argument :attribute, AttrName, :grouped
      end

      def heading
        @heading ||= operand.heading.allbut([attribute]).merge(group_heading)
      end

      def keys
        @keys ||= begin
          grouped_attrs = group_heading.to_attr_list
          operand.keys.map{|k| k + grouped_attrs }
        end
      end

    private

      def group_heading
        op_h = operand.heading
        raise NotSupportedError unless op_h[attribute].respond_to?(:heading)
        op_h[attribute].heading
      end

    end # class Ungroup
  end # module Algebra
end # module Alf
