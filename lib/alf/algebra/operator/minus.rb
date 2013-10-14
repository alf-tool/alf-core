module Alf
  module Algebra
    class Minus
      include Operator
      include Relational
      include Binary

      signature do |s|
      end

      def heading
        @heading ||= left.heading
      end

      def keys
        @keys ||= left.keys
      end

    private

      def _type_check(options)
        same_heading!(left.heading, right.heading)
      end

    end # class Minus
  end # module Algebra
end # module Alf
