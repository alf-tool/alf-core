module Alf
  module Algebra
    class Ungroup
      include Operator, Relational, Unary

      signature do |s|
        s.argument :attribute, AttrName, :grouped
      end

      def heading
        @heading ||= begin
          h = operand.heading.to_hash
          reltype = h.delete(attribute)
          Heading.new(h.merge(reltype.heading.to_hash))
        end
      end

      def keys
        @keys ||= begin
          grouped_attrs = operand.heading[attribute].heading.to_attr_list
          operand.keys.map{|k| k + grouped_attrs }
        end
      end

    end # class Ungroup
  end # module Algebra
end # module Alf
