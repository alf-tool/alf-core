module Alf
  module Operator::Relational
    # 
    # Relational intersection (aka a logical and)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This operator computes the relational intersection between its two 
    # operands. The intersection is simply the set of tuples that appear both
    # in LEFT and RIGHT operands.
    #
    class Intersect < Alf::Operator(__FILE__, __LINE__)
      include Operator, Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature do |s|
      end
      
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
