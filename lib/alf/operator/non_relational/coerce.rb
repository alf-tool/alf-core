module Alf
  module Operator::NonRelational

    # 
    # Force attribute coercion according to a heading
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This operator coerces attributes of the input tuples according to HEADING.
    #
    # EXAMPLE
    #
    #   alf coerce parts -- weight Float color Color
    #
    class Coerce < Alf::Operator(__FILE__, __LINE__)
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
