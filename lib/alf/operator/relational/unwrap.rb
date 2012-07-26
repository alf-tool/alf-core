module Alf
  module Operator
    module Relational
      class Unwrap
        include Operator, Relational, Unary

        signature do |s|
          s.argument :attribute, AttrName, :wrapped
        end

        def heading
          raise NotSupportedError
        end

        def keys
          raise NotSupportedError
        end

      end # class Unwrap
    end # module Relational
  end # module Operator
end # module Alf
