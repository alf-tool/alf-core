module Alf
  module Algebra
    class Restrict
      include Operator, Relational, Unary

      signature do |s|
        s.argument :predicate, Predicate, Predicate.tautology
      end

      def heading
        @heading ||= operand.heading
      end

      def keys
        @keys ||= operand.keys
      end

    end # class Restrict
  end # module Algebra
end # module Alf
