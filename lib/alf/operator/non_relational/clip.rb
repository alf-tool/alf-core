module Alf
  module Operator::NonRelational
    # 
    # Clip input tuples to a subset of attributes
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Keep only name and city attributes
    #   (clip :suppliers, [:name, :city])
    #
    #   # Keep all but name and city attributes
    #   (clip :suppliers, [:name, :city], :allbut => true)
    #
    # DESCRIPTION
    #
    # This operator clips tuples on attributes whose names are specified as 
    # arguments. This is similar to the relational PROJECT operator, expect
    # that this one does not removed duplicates that can occur from clipping.
    # In other words, clipping may lead to bags of tuples instead of sets.
    # 
    # When used in shell, the clipping/projection key is simply taken from
    # commandline arguments:
    #
    #   alf clip suppliers -- name city
    #   alf clip suppliers --allbut -- name city
    #
    class Clip < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
  
      signature do |s|
        s.argument :attr_list, AttrList, []
        s.option :allbut, Boolean, false, "Apply an allbut clipping?"
      end
      
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        @attr_list.project(tuple, @allbut)
      end
  
    end # class Clip
  end # module Operator::NonRelational
end # module Alf
