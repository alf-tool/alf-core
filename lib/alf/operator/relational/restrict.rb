module Alf
  module Operator
    module Relational
      class Restrict
        include Relational, Unary

        signature do |s|
          s.argument :predicate, TuplePredicate, "true"
        end

        def compile
          Engine::Filter.new(operand, predicate)
        end

      end # class Restrict
    end # module Relational
  end # module Operator
end # module Alf
