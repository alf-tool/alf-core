module Alf
  module Operator::Relational
    # 
    # Relational grouping (relation-valued attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ... -- NEWNAME
    #
    # API & EXAMPLE
    #
    #   (group :supplies, [:pid, :qty], :supplying)
    #   (group :supplies, [:sid], :supplying, :allbut => true)
    #
    # DESCRIPTION
    #
    # This operator groups attributes ATTR1 to ATTRN as a new, relation-valued
    # attribute whose name is NEWNAME. When used in shell, names of grouped
    # attributes are taken from commandline arguments, expected the last one
    # which defines the new name to use:
    #
    #   alf group supplies -- pid qty -- supplying
    #   alf group supplies --allbut -- sid -- supplying
    #
    class Group < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      signature do |s|
        s.argument :attributes, ProjectionKey, []
        s.argument :as, AttrName, :group
        s.option :allbut, Boolean, false, 'Group all but specified attributes?'
      end
      
      protected 
  
      # See Operator#_prepare
      def _prepare
        @index = Hash.new{|h,k| h[k] = Set.new} 
        each_input_tuple do |tuple|
          key, rest = @attributes.split(tuple, !@allbut)
          @index[key] << rest
        end
      end
  
      # See Operator#_each
      def _each
        @index.each_pair do |k,v|
          yield(k.merge(@as => Relation.coerce(v)))
        end
      end
  
    end # class Group
  end # module Operator::Relational
end # module Alf
