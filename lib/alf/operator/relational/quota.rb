module Alf
  module Operator::Relational
    class Quota < Alf::Operator()
      include Relational, Experimental, Unary

      signature do |s|
        s.argument :by,            AttrList, []
        s.argument :order,         Ordering, []
        s.argument :summarization, Summarization, {}
      end

      # (see Operator#each)
      def each(&block)
        op = Engine::Sort.new(input, @by.to_ordering + @order)
        op = Engine::Quota::Cesure.new(op, @by, summarization)
        op.each(&block)
      end

    end # class Quota
  end # module Operator::Relational
end # module Alf
