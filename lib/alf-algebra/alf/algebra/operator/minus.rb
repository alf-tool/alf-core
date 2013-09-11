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

    end # class Minus
  end # module Algebra
end # module Alf
