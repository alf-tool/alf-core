module Alf
  module Operator::Relational
    # 
    # Relational un-grouping (inverse of group)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR
    #
    # API & EXAMPLE
    #
    #   # Assuming grouped = (group enum, [:pid, :qty], :supplying)
    #   (ungroup grouped, :supplying)
    #
    # DESCRIPTION
    #
    # This operator ungroups the relation-valued attribute named ATTR and outputs
    # tuples as the flattening of each of of its tuples merged with the upstream
    # one. Sub relation should be such so that no name collision occurs. When 
    # used in shell, the name of the attribute to ungroup is taken as the first 
    # commandline argument:
    #
    #   alf ungroup group -- supplying
    #
    class Ungroup < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      signature do |s|
        s.argument :attribute, AttrName, :wrapped
      end
      
      protected 
  
      # See Operator#_each
      def _each
        each_input_tuple do |tuple|
          tuple = tuple.dup
          subrel = tuple.delete(@attribute)
          subrel.each do |subtuple|
            yield(tuple.merge(subtuple))
          end
        end
      end
  
    end # class Ungroup
  end # module Operator::Relational
end # module Alf
