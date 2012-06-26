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

        # (see Operator#compile)
        def compile(context)
          if @allbut
            Engine::Summarize::Hash.new(operand, by, summarization, allbut, context)
          else
            op = Engine::Sort.new(operand, by.to_ordering, context)
            op = Engine::Summarize::Cesure.new(op, by, summarization, allbut, context)
            op
          end
        end

      end # class Summarize
    end # module Relational
  end # module Operator
end # module Alf
