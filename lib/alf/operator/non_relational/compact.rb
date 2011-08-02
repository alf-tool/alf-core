module Alf
  module Operator::NonRelational
    # 
    # Remove tuple duplicates
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND]
    #
    # API & EXAMPLE
    #
    #   # clip, unlike project, typically leave duplicates
    #   (compact (clip :suppliers, [ :city ]))
    #
    # DESCRIPTION
    #
    # This operator remove duplicates from input tuples. As defaults, it is a non
    # relational operator that helps normalizing input for implementing relational
    # operators. This one is centric in converting bags of tuples to sets of 
    # tuples, as required by true relations.
    #
    #   alf compact ... 
    #
    class Compact < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Shortcut, Operator::Unary
  
      signature do |s|
      end
      
      # Removes duplicates according to a complete order
      class SortBased
        include Operator, Operator::Cesure

        def initialize
          @cesure_key ||= ProjectionKey.new([])
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
