module Alf
  module Operator::NonRelational
    # 
    # Extend its operand with an unique autonumber attribute
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This non-relational operator guarantees uniqueness of output tuples by
    # adding an attribute ATTRNAME whose value is an auto-numbered Integer. 
    # 
    # If the presence of duplicates was the only "non-relational" aspect of 
    # the input, the result is a valid relation for which ATTRNAME is a 
    # candidate key.
    #
    # EXAMPLE
    #
    #   alf autonum suppliers
    #   alf autonum suppliers -- unique_id
    #
    class Autonum < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
    
      signature do |s|
        s.argument :attrname, AttrName, :autonum
      end
          
      protected
        
      # (see Operator#_prepare)
      def _prepare
        @autonum = -1
      end
      
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge(@attrname => (@autonum += 1))
      end
    
    end # class Autonum
  end # module Operator::NonRelational
end # module Alf
