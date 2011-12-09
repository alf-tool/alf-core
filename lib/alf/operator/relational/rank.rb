module Alf
  module Operator::Relational
    class Rank < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :order, Ordering, []
        s.argument :as, AttrName, :rank
      end

      # (see Operator#each)
      def each(&block)
        op = Engine::Sort.new(input, order)
        op = Engine::Rank::Cesure.new(op, order, as)
        op.each(&block)
      end 

    end # class Rank
  end # module Operator::Relational
end # module Alf
