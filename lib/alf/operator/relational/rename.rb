module Alf
  module Operator::Relational
    # 
    # Relational renaming (rename some attributes)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This command renames attributes as specified in RENAMING, taken as 
    # successive (old name, new name) pairs
    #
    # EXAMPLE
    #
    #   alf rename suppliers -- name supplier_name  city supplier_city
    #
    class Rename < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature do |s|
        s.argument :renaming, Renaming, {}
      end
      
      protected 
    
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        @renaming.apply(tuple)
      end
  
    end # class Rename
  end # module Operator::Relational
end # module Alf
