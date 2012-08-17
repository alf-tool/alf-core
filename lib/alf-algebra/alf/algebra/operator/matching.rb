module Alf
  module Algebra
    class Matching
      include Operator, Relational, Binary

      signature do |s|
      end

      def heading
        @heading ||= left.heading
      end

      def keys
        @keys ||= (left.keys + right.keys.select{|k| k.subset?(common_attributes) })
      end

    end # class Matching
  end # module Algebra
end # module Alf
