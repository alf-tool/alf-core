module Alf
  module Operator::Relational
    class Extend < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :ext, TupleComputation, {}
      end

      def each(&block)
        Engine::SetAttr.new(input, ext).each(&block)
      end

    end # class Extend
  end # module Operator::Relational
end # module Alf
