module Alf
  module Operator
    module Relational
      class Ungroup
        include Operator, Relational, Unary

        signature do |s|
          s.argument :attribute, AttrName, :grouped
        end

        def heading
          raise NotSupportedError
        end

        def keys
          raise NotSupportedError
        end

      end # class Ungroup
    end # module Relational
  end # module Operator
end # module Alf
