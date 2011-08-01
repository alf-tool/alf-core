module Alf
  module Operator::Relational
    # 
    # Relational union
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   (union (project :suppliers, [:city]), 
    #          (project :parts,     [:city]))
    #
    # DESCRIPTION
    #
    # This operator computes the union join of two input iterators. Input 
    # iterators should have the same heading. The result never contain duplicates.
    #
    #   alf union ... ...
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
