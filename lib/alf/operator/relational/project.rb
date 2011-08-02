module Alf
  module Operator::Relational
    # Relational projection (clip + compact)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Project on name and city attributes
    #   (project :suppliers, [:name, :city])
    #
    #   # Project on all but name and city attributes
    #   (project :suppliers, [:name, :city], :allbut => true)
    #
    # DESCRIPTION
    #
    # This operator projects tuples on attributes whose names are specified as 
    # arguments. This is similar to clip, except that this ones is a truly 
    # relational one, that is, it also removes duplicates tuples. 
    # 
    # When used in shell, the clipping/projection key is simply taken from
    # commandline arguments:
    #
    #   alf project suppliers -- name city
    #   alf project --allbut suppliers -- name city
    #
    class Project < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
    
      signature do |s|
        s.argument :attr_list, AttrList, []
        s.option :allbut, Boolean, false, 'Project all but specified attributes?'
      end
      
      protected 
    
      # (see Operator::Shortcut#longexpr)
      def longexpr
        chain Operator::NonRelational::Compact.new,
              Operator::NonRelational::Clip.new(@attr_list, {:allbut => @allbut}),
              datasets
      end
    
    end # class Project
  end # module Operator::Relational
end # module Alf
