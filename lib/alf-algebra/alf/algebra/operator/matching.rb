module Alf
  module Algebra
    class Matching
      include Operator
      include Relational
      include Binary

      signature do |s|
      end

      def heading
        @heading ||= left.heading
      end

      def keys
        @keys ||= (left.keys + right.keys.select{|k| k.subset?(common_attributes) })
      end

    private

      def _type_check(options)
        joinable_headings!(left.heading, right.heading, options)
      end

    end # class Matching
  end # module Algebra
end # module Alf
