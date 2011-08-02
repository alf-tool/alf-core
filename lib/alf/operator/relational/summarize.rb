module Alf
  module Operator::Relational
    # 
    # Relational summarization (group-by + aggregate ops)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #
    # This operator summarizes input tuples over a projection given by BY_LIST.
    # SUMMARIZATION is a list of (name, aggregator) pairs.
    #
    # With --allbut, the operator uses all attributes not in BY_LIST as 
    # projection key.
    #
    # EXAMPLE
    #
    #   alf summarize supplies -- sid -- total_qty "sum(:qty)" 
    #   alf summarize supplies --allbut -- pid qty -- total_qty "sum(:qty)" 
    #
    class Summarize < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
      
      signature do |s|
        s.argument :by_list, AttrList, []
        s.argument :summarization, Summarization, {}
        s.option :allbut, Boolean, false, "Summarize on all but specified attributes?"
      end
      
      # Summarizes according to a complete order
      class SortBased
        include Operator, Operator::Cesure
  
        def initialize(by_key, allbut, summarization)
          @by_key, @allbut, @summarization = by_key, allbut, summarization
        end
  
        protected 
  
        # (see Operator::Cesure#project)
        def project(tuple)
          @by_key.project(tuple, @allbut)
        end
        
        # (see Operator::Cesure#start_cesure)
        def start_cesure(key, receiver)
          @aggs = @summarization.least
        end
  
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          @aggs = @summarization.happens(@aggs, tuple)
        end
  
        # (see Operator::Cesure#flush_cesure)
        def flush_cesure(key, receiver)
          @aggs = @summarization.finalize(@aggs)
          receiver.call key.merge(@aggs)
        end
  
      end # class SortBased

      # Summarizes in-memory with a hash
      class HashBased
        include Operator, Operator::Relational, Operator::Unary
  
        def initialize(by_key, allbut, summarization)
          @by_key, @allbut, @summarization = by_key, allbut, summarization
        end

        protected
        
        def _each
          index = Hash.new{|h,k| @summarization.least}
          each_input_tuple do |tuple|
            key, rest = @by_key.split(tuple, @allbut)
            index[key] = @summarization.happens(index[key], tuple)
          end
          index.each_pair do |key,aggs|
            yield key.merge(@summarization.finalize(aggs))
          end
        end
      
      end
        
      protected 
      
      def longexpr
        if @allbut
          chain HashBased.new(@by_list, @allbut, @summarization),
                datasets
        else
          chain SortBased.new(@by_list, @allbut, @summarization),
                Operator::NonRelational::Sort.new(@by_list.to_ordering),
                datasets
        end
      end
  
    end # class Summarize
  end # module Operator::Relational
end # module Alf
