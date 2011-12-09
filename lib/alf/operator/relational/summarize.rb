module Alf
  module Operator::Relational
    class Summarize < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :by,            AttrList, []
        s.argument :summarization, Summarization, {}
        s.option   :allbut,        Boolean, false, "Summarize on all but specified attributes?"
      end

      # (see Operator#compile)
      def compile
        if @allbut
          Engine::Summarize::Hash.new(operand, by, summarization, allbut)
        else
          op = Engine::Sort.new(operand, by.to_ordering)
          op = Engine::Summarize::Cesure.new(op, by, summarization, allbut)
          op
        end
      end
  
    end # class Summarize
  end # module Operator::Relational
end # module Alf
