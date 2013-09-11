module Alf
  module Algebra
    class Extend
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :ext, TupleComputation, {}
      end

      def heading
        @heading ||= operand.heading.merge(ext.to_heading)
      end

      def keys
        @keys ||= begin
          attrs = ext.to_attr_list
          operand.keys.reject{|k| k.intersect?(attrs) }
        end
      end

    end # class Extend
  end # module Algebra
end # module Alf
