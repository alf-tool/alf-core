module Alf
  module Operator::NonRelational
    class Defaults < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
        s.argument :defaults, TupleComputation, {}
        s.option   :strict,   Boolean, false, "Restrict to default attributes only?"
      end

      def each(&block)
        op = Engine::Defaults.new(input, defaults)
        op = Engine::Clip.new(op, defaults.to_attr_list, false) if strict
        op.each(&block)
      end

    end # class Defaults
  end # module Operator::NonRelational
end # module Alf
