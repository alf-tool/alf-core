module Alf
  module Operator::Relational
    # 
    # Relational un-wraping (inverse of wrap)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This operator flattens its operand by unwrapping the tuple-valued 
    # attribute ATTR.
    #
    class Unwrap < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature do |s|
        s.argument :attr, AttrName, :wrapped
      end
      
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple = tuple.dup
        wrapped = tuple.delete(@attr) || {}
        tuple.merge(wrapped)
      end
  
    end # class Unwrap
  end # module Operator::Relational
end # module Alf
