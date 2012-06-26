module Alf
  module Operator
    module Relational
      class Rank
        include Operator, Relational, Unary

        signature do |s|
          s.argument :order, Ordering, []
          s.argument :as, AttrName, :rank
        end

        # (see Operator#each)
        def compile(context)
          op = Engine::Sort.new(operand, order, context)
          op = Engine::Rank::Cesure.new(op, order, as, context)
          op
        end

      end # class Rank
    end # module Relational
  end # module Operator
end # module Alf
