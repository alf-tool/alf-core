module Alf
  module Operator::Relational
    class Project < Alf::Operator()
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
