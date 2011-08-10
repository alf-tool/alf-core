module Alf
  module Operator::Relational
    class Group < Alf::Operator()
      include Operator::Relational, Operator::Unary
      
      signature do |s|
        s.argument :attributes, AttrList, []
        s.argument :as,         AttrName, :group
        s.option   :allbut,     Boolean,  false, 'Group all but specified attributes?'
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
