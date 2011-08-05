module Alf
  module Operator::Relational
    class Union < Alf::Operator()
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
