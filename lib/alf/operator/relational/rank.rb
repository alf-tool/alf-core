module Alf
  module Operator::Relational
    # 
    # Relational ranking (explicit tuple positions)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ORDERING -- [RANKNAME]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Position attribute => # of tuples with smaller weight 
    #   (rank :parts, [:weight], :position)
    #    
    #   # Position attribute => # of tuples with greater weight 
    #   (rank :parts, [[:weight, :desc]], :position)
    #
    # DESCRIPTION
    #
    # This operator computes the ranking of input tuples, according to an order
    # relation. Precisely, it extends the input tuples with a RANKNAME attribute
    # whose value is the number of tuples which are considered strictly less
    # according to the specified order. For the two examples above:
    #
    #   alf rank parts -- weight -- position
    #   alf rank parts -- weight desc -- position
    #
    # Note that, unless the ordering key includes a candidate key for the input
    # relation, the newly RANKNAME attribute is not necessarily a candidate key
    # for the output one. In the example above, adding the :pid attribute 
    # ensured that position will contain all different values: 
    #
    #   alf rank parts -- weight pid -- position
    # 
    # Or even:
    #
    #   alf rank parts -- weight desc pid asc -- position
    #
    class Rank < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
  
      signature do |s|
        s.argument :order, OrderingKey, []
        s.argument :ranking_name, AttrName, :rank
      end
      
      class SortBased
        include Operator, Operator::Cesure
        
        def initialize(order, ranking_name)
          @by_key = ProjectionKey.coerce(order)
          @ranking_name = ranking_name
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
          receiver.call tuple.merge(@ranking_name => @rank)
          @last_block += 1
        end
        
        # (see Operator::Cesure#flush_cesure)
        def flush_cesure(key, receiver)
          @rank += @last_block
        end
  
      end # class SortBased
  
      protected
      
      def longexpr
        chain SortBased.new(@order, @ranking_name),
              Operator::NonRelational::Sort.new(@order),
              datasets
      end 
  
    end # class Rank
  end # module Operator::Relational
end # module Alf
