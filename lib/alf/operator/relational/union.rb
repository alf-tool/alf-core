module Alf
  module Operator::Relational
    # 
    # Relational union
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This operator computes the union of its operands, that is the set of 
    # tuples that appear in LEFT or in RIGHT. 
    #
    # The result is a valid relation in that it never contains duplicates.
    #
    class Union < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature do |s|
      end
      
      class DisjointBased
        include Operator, Operator::Binary
      
        protected
        
        def _each
          left.each(&Proc.new)
          right.each(&Proc.new)
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain Operator::NonRelational::Compact.new,
              DisjointBased.new,
              datasets 
      end
      
    end # class Union
  end # module Operator::Relational
end # module Alf
