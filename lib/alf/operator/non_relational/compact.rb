module Alf
  module Operator::NonRelational
    # 
    # Remove tuple duplicates
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This non-relational operator removes duplicates from its input operand.
    # In other words, it converts a bag of tuples to a set of tuples in a 
    # brute-force manner.
    #
    # If the presence of duplicates was the only "non-relational" aspect of 
    # the operand, the result is a valid relation.
    #
    # EXAMPLE
    #
    #   alf compact suppliers
    #
    class Compact < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Shortcut, Operator::Unary
  
      signature do |s|
      end
      
      # Removes duplicates according to a complete order
      class SortBased
        include Operator, Operator::Cesure

        def initialize
          @cesure_key ||= AttrList.new([])
        end
          
        protected
        
        # (see Operator::Cesure#project)
        def project(tuple)
          @cesure_key.project(tuple, true)
        end
  
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          @tuple = tuple
        end
  
        # (see Operator::Cesure#flush_cesure)
        def flush_cesure(key, receiver)
          receiver.call(@tuple)
        end
 
      end # class SortBased
  
      # Removes duplicates by loading all in memory and filtering 
      # them there 
      class BufferBased
        include Operator, Operator::Unary
  
        protected
        
        def _prepare
          @tuples = input.to_a.uniq
        end
  
        def _each
          @tuples.each(&Proc.new)
        end
  
      end # class BufferBased
  
      protected 
      
      def longexpr
        chain BufferBased.new,
              datasets
      end
  
    end # class Compact
  end # module Operator::NonRelational
end # module Alf
