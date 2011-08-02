module Alf
  module Operator::Relational
    # 
    # Relational wraping (tuple-valued attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ... -- NEWNAME
    #
    # API & EXAMPLE
    #
    #   (wrap :suppliers, [:city, :status], :loc_and_status)
    #
    # DESCRIPTION
    #
    # This operator wraps attributes ATTR1 to ATTRN as a new, tuple-based
    # attribute whose name is NEWNAME. When used in shell, names of wrapped 
    # attributes are taken from commandline arguments, expected the last one
    # which defines the new name to use:
    #
    #   alf wrap suppliers -- city status -- loc_and_status
    #
    class Wrap < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature do |s|
        s.argument :attributes, AttrList, []
        s.argument :as, AttrName, :wrapped
      end
      
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        wrapped, others = @attributes.split(tuple)
        others[@as] = wrapped
        others
      end
  
    end # class Wrap
  end # module Operator::Relational
end # module Alf
