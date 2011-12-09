module Alf
  module Operator::Relational
    class Restrict < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :predicate, TuplePredicate, "true"
      end

      def compile
        Engine::Filter.new(operand, predicate)
      end

    end # class Restrict
  end # module Operator::Relational
end # module Alf
