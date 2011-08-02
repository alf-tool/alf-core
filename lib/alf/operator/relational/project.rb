module Alf
  module Operator::Relational
    #
    # Relational projection (clip + compact)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #
    # This operator projects tuples on attributes whose names are specified in 
    # ATTR_LIST. Unlike SQL, this operator **always** removes duplicates in the
    # result so that the output is a set of tuples, that is, a relation.
    #
    # With --allbut, the operators projects attributes in ATTR_LIST away instead 
    # of keeping them. 
    # 
    # EXAMPLE
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
