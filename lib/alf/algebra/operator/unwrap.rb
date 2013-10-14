module Alf
  module Algebra
    class Unwrap
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :attribute, AttrName, :wrapped
      end

      def heading
        @heading ||= begin
          op_h = operand.heading
          op_h.allbut([attribute]).merge(op_h[attribute].heading)
        end
      end

      def keys
        operand.keys
      end

    private

      def _type_check(options)
        ungrouped = operand.heading[attribute]
        unless ungrouped.ancestors.include?(Tuple)
          type_check_error!("not a tuple-valued attribute `#{attribute}` (#{ungrouped})")
        end
        no_name_clash!(operand.attr_list, ungrouped.heading.to_attr_list)
      end

    end # class Unwrap
  end # module Algebra
end # module Alf
