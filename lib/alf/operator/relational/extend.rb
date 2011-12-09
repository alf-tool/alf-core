module Alf
  module Operator::Relational
    class Extend < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :ext, TupleComputation, {}
      end

      # (see Operator#compile)
      def compile
        Engine::SetAttr.new(operand, ext)
      end

    end # class Extend
  end # module Operator::Relational
end # module Alf
