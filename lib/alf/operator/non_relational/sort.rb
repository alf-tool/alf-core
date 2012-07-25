module Alf
  module Operator
    module NonRelational
      class Sort
        include Operator, NonRelational, Unary

        signature do |s|
          s.argument :ordering, Ordering, []
        end

        def heading
          @heading ||= operand.heading
        end

        def keys
          @keys ||= operand.keys
        end

      end # class Sort
    end # module NonRelational
  end # module Operator
end # module Alf
