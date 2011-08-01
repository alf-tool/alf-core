module Alf
  module Operator::Relational
    # 
    # Relational minus (aka difference)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   # Give all suppliers but those living in Paris
    #   (minus :suppliers, 
    #          (restrict :suppliers, lambda{ city == 'Paris' }))
    #
    # DESCRIPTION
    #
    # This operator computes the difference between its two operands. The 
    # difference is simply the set of tuples in left operands non shared by
    # the right one.
    #
    #   alf minus ... ...
    #  
    class Minus < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature []
      
      class HashBased
        include Operator, Operator::Binary
      
        protected
        
        def _prepare
          @index = Hash.new
          right.each{|t| @index[t] = true}
        end
        
        def _each
          left.each do |left_tuple|
            yield(left_tuple) unless @index.has_key?(left_tuple)
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Minus
  end # module Operator::Relational
end # module Alf
