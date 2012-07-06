module Alf
  module Operator
    module Relational
      class Quota
        include Operator, Relational, Unary, Experimental

        signature do |s|
          s.argument :by,            AttrList, []
          s.argument :order,         Ordering, []
          s.argument :summarization, Summarization, {}
        end

      end # class Quota
    end # module Relational
  end # module Operator
end # module Alf
