module Alf
  module Algebra
    class Union
      include Operator
      include Relational
      include Binary

      signature do |s|
      end

      def heading
        @heading ||= left.heading + right.heading
      end

      def keys
        @keys ||= Keys[ heading.to_attr_list ]
      end

    end # class Union
  end # module Algebra
end # module Alf
