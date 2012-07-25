module Alf
  module Operator
    module NonRelational
      class Coerce
        include Operator, NonRelational, Unary

        signature do |s|
          s.argument :coercions, Heading, {}
        end

        def heading
          @heading ||= operand.heading.merge(coercions)
        end

        def keys
          @keys ||= operand.keys
        end

      end # class Coerce
    end # module NonRelational
  end # module Operator
end # module Alf
