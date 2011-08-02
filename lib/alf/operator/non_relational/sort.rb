module Alf
  module Operator::NonRelational
    # 
    # Sort input tuples according to an order relation
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This non-relational operator sorts input tuples according to ORDERING. 
    #
    # This is, of course, a non relational operator as relations are unordered 
    # sets. It is provided for displaying purposes and normalization of 
    # non-relational inputs.
    #
    # EXAMPLE
    #
    #   alf sort suppliers -- name asc
    #   alf sort suppliers -- city desc name asc
    #
    class Sort < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Unary

      signature do |s|
        s.argument :ordering, Ordering, []
      end
          
      protected 
    
      def _prepare
        @buffer = Buffer::Sorted.new(ordering)
        @buffer.add_all(input)
      end
    
      def _each
        @buffer.each(&Proc.new)
      end
    
    end # class Sort
  end # module Operator::NonRelational
end # module Alf
