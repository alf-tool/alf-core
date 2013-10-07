module Alf
  module Algebra
    class Ungroup
      include Operator
      include Relational
      include Unary

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

      def _type_check(options)
        ungrouped = operand.heading[attribute]
        unless ungrouped.ancestors.include?(Relation)
          type_check_error!("not a relation-valued attribute `#{attribute}` (#{ungrouped})")
        end
        no_name_clash!(operand.attr_list, ungrouped.heading.to_attr_list)
      end

    end # class Ungroup
  end # module Algebra
end # module Alf
