module Alf
  module Operator::Relational
    class Rank < Alf::Operator()
      include Operator::Relational, Operator::Shortcut, Operator::Unary
  
      signature do |s|
        s.argument :ordering, Ordering, []
        s.argument :rank_name, AttrName, :rank
      end
      
      class SortBased
        include Operator, Operator::Cesure
        
        def initialize(ordering, rank_name)
          @by_key = AttrList.coerce(ordering)
          @rank_name = rank_name
        end
        
        protected
        
        # (see Operator::Cesure#project)
        def project(tuple)
          @by_key.project(tuple, false)
        end
    
        # (see Operator::Cesure#start_cesure)
        def start_cesure(key, receiver)
          @rank ||= 0
          @last_block = 0
        end
  
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          receiver.call tuple.merge(@rank_name => @rank)
          @last_block += 1
        end
        
        # (see Operator::Cesure#flush_cesure)
        def flush_cesure(key, receiver)
          @rank += @last_block
        end
  
      end # class SortBased
  
      protected
      
      def longexpr
        chain SortBased.new(@ordering, @rank_name),
              Operator::NonRelational::Sort.new(@ordering),
              datasets
      end 
  
    end # class Rank
  end # module Operator::Relational
end # module Alf
