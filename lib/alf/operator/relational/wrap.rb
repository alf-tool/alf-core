module Alf
  module Operator::Relational
    class Wrap < Alf::Operator()
      include Operator::Relational, Operator::Transform
  
      signature do |s|
        s.argument :attr_list, AttrList, []
        s.argument :as, AttrName, :wrapped
      end
      
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        wrapped, others = @attr_list.split(tuple)
        others[@as] = wrapped
        others
      end
  
    end # class Wrap
  end # module Operator::Relational
end # module Alf
