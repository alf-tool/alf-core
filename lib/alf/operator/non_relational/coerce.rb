module Alf
  module Operator::NonRelational
    class Coerce < Alf::Operator()
      include Operator::NonRelational, Operator::Transform
    
      signature do |s|
        s.argument :heading, Heading, {}
      end
      
      protected 
      
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge tuple_collect(@heading.attributes){|k,d|
          [k, coerce(tuple[k], d)]
        }
      end
    
    end # class Coerce
  end # module Operator::NonRelational
end # module Alf
