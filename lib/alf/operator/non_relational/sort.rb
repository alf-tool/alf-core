module Alf
  module Operator::NonRelational
    # 
    # Sort input tuples according to an order relation
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ORDER1 ATTR2 ORDER2...
    #
    # API & EXAMPLE
    #
    #   # sort on supplier name in ascending order
    #   (sort :suppliers, [:name])
    #
    #   # sort on city then on name
    #   (sort :suppliers, [:city, :name])
    # 
    #   # sort on city DESC then on name ASC
    #   (sort :suppliers, [[:city, :desc], [:name, :asc]])
    #
    #   => See OrderingKey about specifying orderings
    #
    # DESCRIPTION
    #
    # This operator sorts input tuples on ATTR1 then ATTR2, etc. and outputs 
    # them sorted after that. This is, of course, a non relational operator as 
    # relations are unordered sets. It is provided to implement operators that
    # need tuples to be sorted to work correctly. When used in shell, the key 
    # ordering must be specified in its longest form:
    #
    #   alf sort suppliers -- name asc
    #   alf sort suppliers -- city desc name asc
    #
    # LIMITATIONS
    #
    # The fact that the ordering must be completely specified with commandline
    # arguments is a limitation, shortcuts could be provided in the future.
    #
    class Sort < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Unary

      signature [
        [:ordering, OrderingKey, []]
      ]
          
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
