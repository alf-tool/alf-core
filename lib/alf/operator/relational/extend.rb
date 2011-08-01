module Alf
  module Operator::Relational
    #
    # Relational extension (additional, computed attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 EXPR1 ATTR2 EXPR2...
    #
    # API & EXAMPLE
    #
    #   (extend :supplies, :sp  => lambda{ sid + "/" + pid },
    #                      :big => lambda{ qty > 100 ? true : false }) 
    #
    # DESCRIPTION
    #
    # This command extend input tuples with new attributes (named ATTR1, ...)  
    # whose value is the result of evaluating tuple expressions (i.e. EXPR1, ...).
    # See main documentation about the semantics of tuple expressions. When used
    # in shell, the hash of extensions is built from commandline arguments ala
    # Hash[...]. Tuple expressions must be specified as code literals there:
    #
    #   alf extend supplies -- sp 'sid + "/" + pid' big "qty > 100 ? true : false"
    #
    # Attributes ATTRx should not already exist, no behavior is guaranteed if 
    # this precondition is not respected.   
    #
    class Extend < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature do |s|
        s.argument :extensions, TupleComputation, {}
      end
      
      protected 
    
      # (see Operator#_prepare)
      def _prepare
        @handle = TupleHandle.new
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge @extensions.evaluate(@handle.set(tuple))
      end
  
    end # class Extend
  end # module Operator::Relational
end # module Alf
