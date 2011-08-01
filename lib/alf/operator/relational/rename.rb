module Alf
  module Operator::Relational
    # 
    # Relational renaming (rename some attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- OLD1 NEW1 ...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   (rename :suppliers, :name => :supplier_name, :city => :supplier_city)
    #
    # DESCRIPTION
    #
    # This command renames OLD attributes as NEW as specified by arguments. 
    # Attributes OLD should exist in source tuples while attributes NEW should 
    # not. When used in shell, renaming attributes are built ala Hash[...] from
    # commandline arguments: 
    #
    #   alf rename suppliers -- name supplier_name city supplier_city
    #
    class Rename < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature [
        [:renaming, Renaming, {}]
      ]
      
      protected 
    
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        @renaming.apply(tuple)
      end
  
    end # class Rename
  end # module Operator::Relational
end # module Alf
