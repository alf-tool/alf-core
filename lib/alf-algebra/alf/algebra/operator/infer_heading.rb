module Alf
  module Algebra
    class InferHeading
      include Operator, Relational, Unary, Experimental

      signature do |s|
      end

      def heading
        raise NotSupportedError
      end

      def keys
        @keys ||= Keys[ [] ]
      end

    end # class InferHeading
  end # module Algebra
end # module Alf
