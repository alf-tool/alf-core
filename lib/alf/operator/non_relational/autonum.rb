module Alf
  module Operator::NonRelational
    class Autonum < Alf::Operator()
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
