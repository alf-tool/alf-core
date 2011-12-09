module Alf
  module Operator::Relational
    class Unwrap < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :attribute, AttrName, :wrapped
      end

      # (see Operator#compile)
      def compile
        Engine::Unwrap.new(operand, attribute)
      end

    end # class Unwrap
  end # module Operator::Relational
end # module Alf
