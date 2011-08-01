module Alf
  module Operator::NonRelational
    # 
    # Extend its operand with an unique autonumber attribute
    #
    # SYNOPSIS
    #
    # #{program_name} #{command_name} [OPERAND] -- [ATTRNAME]
    #
    # DESCRIPTION
    #
    # This non-relational operator guarantees uniqueness of output tuples by
    # adding an attribute called 'ATTRNAME' whose value is an Integer. No 
    # guarantee is given about ordering of output tuples, nor to the fact
    # that this autonumber is sequential. Only that all values are different.
    # If the presence of duplicates was the only "non-relational" aspect of
    # input tuples, the result may be considered a valid relation representation.
    #
    # IN RUBY
    #
    #   (autonum OPERAND, ATTRNAME = :autonum)
    #
    #   (autonum :suppliers)
    #   (autonum :suppliers, :unique_id)
    #
    # IN SHELL
    #
    #   #{program_name} #{command_name} [OPERAND] -- [ATTRNAME]
    #
    #   alf autonum suppliers
    #   alf autonum suppliers -- unique_id
    #
    class Autonum < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
    
      signature do |s|
        s.argument :attrname, AttrName, :autonum
      end
          
      protected
        
      # (see Operator#_prepare)
      def _prepare
        @autonum = -1
      end
      
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge(@attrname => (@autonum += 1))
      end
    
    end # class Autonum
  end # module Operator::NonRelational
end # module Alf
