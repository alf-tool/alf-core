module Alf
  module Operator::Relational
    # 
    # Relational un-wraping (inverse of wrap)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR
    #
    # API & EXAMPLE
    #
    #   # Assuming wrapped = (wrap :suppliers, [:city, :status], :loc_and_status) 
    #   (unwrap wrapped, :loc_and_status)
    #
    # DESCRIPTION
    #
    # This operator unwraps the tuple-valued attribute named ATTR so as to 
    # flatten its pairs with 'upstream' tuple. The latter should be such so that
    # no name collision occurs. When used in shell, the name of the attribute to
    # unwrap is taken as the first commandline argument:
    #
    #   alf unwrap wrap -- loc_and_status
    #
    class Unwrap < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature do |s|
        s.argument :attribute, AttrName, :wrapped
      end
      
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple = tuple.dup
        wrapped = tuple.delete(@attribute) || {}
        tuple.merge(wrapped)
      end
  
    end # class Unwrap
  end # module Operator::Relational
end # module Alf
