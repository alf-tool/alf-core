module Alf
  module Operator::NonRelational
    class Coerce < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
        s.argument :heading, Heading, {}
      end

      # (see Operator#compile)
      def compile
        Engine::Coerce.new(operand, heading)
      end

    end # class Coerce
  end # module Operator::NonRelational
end # module Alf
