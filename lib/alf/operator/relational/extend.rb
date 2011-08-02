module Alf
  module Operator::Relational
    #
    # Relational extension (additional, computed attributes)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This operator extends its operand with new attributes whose value is the 
    # result of evaluating tuple expressions. The latter are specified as 
    # (name, tuple expression) pairs. Tuple expressions must be specified as 
    # ruby code literals. 
    #
    # EXAMPLE
    #
    #   alf extend supplies -- big "qty > 100"  price "qty * 12.2"
    #
    class Extend < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature do |s|
        s.argument :extensions, TupleComputation, {}
      end
      
      protected 
    
      # (see Operator#_prepare)
      def _prepare
        @handle = TupleHandle.new
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge @extensions.evaluate(@handle.set(tuple))
      end
  
    end # class Extend
  end # module Operator::Relational
end # module Alf
