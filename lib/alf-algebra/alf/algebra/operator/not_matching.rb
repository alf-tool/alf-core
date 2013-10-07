module Alf
  module Algebra
    class NotMatching
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
        joinable_headings!(left.heading, right.heading, options)
      end

    end # class NotMatching
  end # module Algebra
end # module Alf
