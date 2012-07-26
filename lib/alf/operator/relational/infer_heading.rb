module Alf
  module Operator
    module Relational
      class InferHeading
        include Operator, Relational, Unary, Experimental

        signature do |s|
        end

        def heading
          raise NotSupportedError
        end

        def keys
          @keys ||= [ AttrList[] ].freeze
        end

      end # class InferHeading
    end # module Relational
  end # module Operator
end # module Alf
