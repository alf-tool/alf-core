module Alf
  module Operator::Relational
    class Extend < Alf::Operator()
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
