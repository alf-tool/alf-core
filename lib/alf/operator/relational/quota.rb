module Alf
  module Operator
    module Relational
      class Quota
        include Relational, Unary, Experimental

        signature do |s|
          s.argument :by,            AttrList, []
          s.argument :order,         Ordering, []
          s.argument :summarization, Summarization, {}
        end

        # (see Operator#compile)
        def compile
          op = Engine::Sort.new(operand, @by.to_ordering + @order)
          op = Engine::Quota::Cesure.new(op, @by, summarization)
          op
        end

      end # class Quota
    end # module Relational
  end # module Operator
end # module Alf
