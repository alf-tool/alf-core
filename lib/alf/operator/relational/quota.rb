module Alf
  module Operator::Relational
    class Quota < Alf::Operator()
      include Operator::Relational, Operator::Experimental,
              Operator::Shortcut, Operator::Unary
  
      signature do |s|
        s.argument :by,            AttrList, []
        s.argument :order,         Ordering, []
        s.argument :summarization, Summarization, {}
      end
      
      class SortBased
        include Operator, Operator::Cesure
        
        def initialize(by, order, summarization)
          @by, @order, @summarization  = by, order, summarization
        end
        
        protected
        
        # (see Operator::Cesure#project)
        def project(tuple)
          @by.project_tuple(tuple, false)
        end
        
        # (see Operator::Cesure#start_cesure)
        def start_cesure(key, receiver)
          @aggs = @summarization.least
        end
    
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          @aggs = @summarization.happens(@aggs, tuple)
          receiver.call tuple.merge(@summarization.finalize(@aggs))
        end
  
      end # class SortBased
  
      protected
      
      def longexpr
        sort_key = @by.to_ordering + @order
        chain SortBased.new(@by, @order, @summarization),
              Operator::NonRelational::Sort.new(sort_key),
              datasets
      end 
  
    end # class Quota
  end # module Operator::Relational
end # module Alf
