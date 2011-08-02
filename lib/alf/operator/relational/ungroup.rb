module Alf
  module Operator::Relational
    # 
    # Relational un-grouping (inverse of group)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This operator flattens its operand by ungrouping the relation-valued 
    # attribute ATTR. 
    #
    # EXAMPLE
    #
    #   alf ungroup group -- supplying
    #
    class Ungroup < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      signature do |s|
        s.argument :attr, AttrName, :grouped
      end
      
      protected 
  
      # See Operator#_each
      def _each
        each_input_tuple do |tuple|
          tuple = tuple.dup
          subrel = tuple.delete(@attr)
          subrel.each do |subtuple|
            yield(tuple.merge(subtuple))
          end
        end
      end
  
    end # class Ungroup
  end # module Operator::Relational
end # module Alf
