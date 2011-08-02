module Alf
  module Operator::Relational
    # 
    # Generalized quota-queries (position, sum progression, etc.)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # **This operator is a work in progress and should be used with care.**
    # 
    # This operator is an attempt to generalize RANK in two ways:
    #   * Use a full SUMMARIZATION instead of hard-coding a ranking attribute 
    #     through count()
    #   * Providing a BY key so that sumarizations can actually be done on 
    #     sub-groups
    #
    # EXAMPLE
    #
    #   alf quota supplies -- sid -- qty -- position count sum_qty "sum(:qty)"
    #
    class Quota < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Experimental,
              Operator::Shortcut, Operator::Unary
  
      signature do |s|
        s.argument :by, AttrList, []
        s.argument :ordering, Ordering, []
        s.argument :summarization, Summarization, {}
      end
      
      class SortBased
        include Operator, Operator::Cesure
        
        def initialize(by, ordering, summarization)
          @by, @ordering, @summarization  = by, ordering, summarization
        end
        
        protected
        
        # (see Operator::Cesure#project)
        def project(tuple)
          @by.project(tuple, false)
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
        sort_key = @by.to_ordering + @ordering
        chain SortBased.new(@by, @ordering, @summarization),
              Operator::NonRelational::Sort.new(sort_key),
              datasets
      end 
  
    end # class Quota
  end # module Operator::Relational
end # module Alf
