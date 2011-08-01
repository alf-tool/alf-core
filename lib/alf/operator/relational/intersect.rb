module Alf
  module Operator::Relational
    # 
    # Relational intersection (aka a logical and)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   # Give suppliers that live in Paris and have status >= 20
    #   (intersect \\
    #     (restrict :suppliers, lambda{ status >= 20 }),
    #     (restrict :suppliers, lambda{ city == 'Paris' }))
    #
    # DESCRIPTION
    #
    # This operator computes the intersection between its two operands. The 
    # intersection is simply the set of common tuples between them. Both operands
    # must have the same heading. 
    #
    #   alf intersect ... ...
    #  
    class Intersect < Alf::Operator(__FILE__, __LINE__)
      include Operator, Operator::Relational, Operator::Shortcut, Operator::Binary
      
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
            yield(left_tuple) if @index.has_key?(left_tuple)
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Intersect
  end # module Operator::Relational
end # module Alf
