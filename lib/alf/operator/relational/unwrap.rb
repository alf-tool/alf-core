module Alf
  module Operator::Relational
    class Unwrap < Alf::Operator()
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
