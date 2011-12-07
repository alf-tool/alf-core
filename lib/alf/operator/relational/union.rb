module Alf
  module Operator::Relational
    class Union < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      def each(&block)
        op = Engine::Concat.new([left, right])
        op = Engine::Compact.new(op)
        op.each(&block)
      end

    end # class Union
  end # module Operator::Relational
end # module Alf
