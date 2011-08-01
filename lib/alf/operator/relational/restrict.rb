module Alf
  module Operator::Relational
    # 
    # Relational restriction (aka where, predicate filtering)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- EXPR
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 VAL1 ...
    #
    # API & EXAMPLE
    #
    #   # Restrict to suppliers with status greater than 20
    #   (restrict :suppliers, lambda{ status > 20 })
    #
    #   # Restrict to suppliers that live in London
    #   (restrict :suppliers, lambda{ city == 'London' })
    #
    # DESCRIPTION
    #
    # This command restricts tuples to those for which EXPR evaluates to true.
    # EXPR must be a valid tuple expression that should return a truth-value.
    # When used in shell, the predicate is taken as a string and coerced to a
    # TupleExpression. We also provide a shortcut for equality expressions. 
    # Note that, in that case, values are expected to be ruby code literals,
    # evaluated with Kernel.eval. Therefore, strings must be doubly quoted.  
    #
    #   alf restrict suppliers -- "status > 20"
    #   alf restrict suppliers -- city "'London'"
    #
    class Restrict < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      signature do |s|
        s.argument :predicate, Restriction, "true"
      end
      
      protected 
    
      # (see Operator#_each)
      def _each
        handle = TupleHandle.new
        each_input_tuple{|t| yield(t) if @predicate.evaluate(handle.set(t)) }
      end
  
    end # class Restrict
  end # module Operator::Relational
end # module Alf
