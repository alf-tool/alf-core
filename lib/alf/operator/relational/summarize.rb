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

        def heading
          @heading ||= begin
            op_h = operand.heading.project(by, allbut)
            op_h.merge(summarization.to_heading)
          end
        end

      end # class Summarize
    end # module Relational
  end # module Operator
end # module Alf
