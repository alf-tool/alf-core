module Alf
  module Operator::Relational
    # 
    # Relational wraping (tuple-valued attributes)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This operator wraps attributes in ATTR_LIST as a new, tuple-valued
    # attribute named AS.
    #
    # With --allbut, it wraps all attributes not specified in ATTR_LIST instead.
    #
    # EXAMPLE
    #
    #   alf wrap suppliers -- city status -- loc_and_status
    #
    class Wrap < Alf::Operator(__FILE__, __LINE__)
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
