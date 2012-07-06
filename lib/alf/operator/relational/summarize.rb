module Alf
  module Operator
    module Relational
      class Summarize
        include Operator, Relational, Unary

        signature do |s|
          s.argument :by,            AttrList, []
          s.argument :summarization, Summarization, {}
          s.option   :allbut,        Boolean, false, "Summarize on all but specified attributes?"
        end

      end # class Summarize
    end # module Relational
  end # module Operator
end # module Alf
