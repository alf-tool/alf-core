module Alf
  module Operator::Relational
    class Rank < Alf::Operator()
      include Operator::Relational, Operator::Shortcut, Operator::Unary
  
      signature do |s|
        s.argument :order, Ordering, []
        s.argument :as, AttrName, :rank
      end
      
      class SortBased
        include Operator, Operator::Cesure
        
        def initialize(order, as)
          @by_key = AttrList.coerce(order)
          @as = as
        end
        
        protected
        
        # (see Operator::Cesure#project)
        def project(tuple)
          @by_key.project_tuple(tuple, false)
        end
    
        # (see Operator::Cesure#start_cesure)
        def start_cesure(key, receiver)
          @rank ||= 0
          @last_block = 0
        end
  
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          receiver.call tuple.merge(@as => @rank)
          @last_block += 1
        end
        
        # (see Operator::Cesure#flush_cesure)
        def flush_cesure(key, receiver)
          @rank += @last_block
        end
  
      end # class SortBased
  
      protected
      
      def longexpr
        chain SortBased.new(@order, @as),
              Operator::NonRelational::Sort.new(@order),
              datasets
      end 
  
    end # class Rank
  end # module Operator::Relational
end # module Alf
