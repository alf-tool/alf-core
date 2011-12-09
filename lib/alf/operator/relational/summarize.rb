module Alf
  module Operator::Relational
    class Summarize < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :by,            AttrList, []
        s.argument :summarization, Summarization, {}
        s.option   :allbut,        Boolean, false, "Summarize on all but specified attributes?"
      end

      # (see Operator#each)
      def each(&block)
        if @allbut
          op = Engine::Summarize::Hash.new(input, by, summarization, allbut)
          op.each(&block)
        else
          op = Engine::Sort.new(input, by.to_ordering)
          op = Engine::Summarize::Cesure.new(op, by, summarization, allbut)
          op.each(&block)
        end
      end
  
    end # class Summarize
  end # module Operator::Relational
end # module Alf
