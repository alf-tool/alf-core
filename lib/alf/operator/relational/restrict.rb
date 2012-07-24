module Alf
  module Operator
    module Relational
      class Restrict
        include Operator, Relational, Unary

        signature do |s|
          s.argument :predicate, TuplePredicate, "true"
        end

        def heading
          @heading ||= operand.heading
        end

      end # class Restrict
    end # module Relational
  end # module Operator
end # module Alf
