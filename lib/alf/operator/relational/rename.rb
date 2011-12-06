module Alf
  module Operator::Relational
    class Rename < Alf::Operator()
      include Operator::Relational, Operator::Transform
  
      signature do |s|
        s.argument :renaming, Renaming, {}
      end
      
      protected 
    
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        @renaming.rename_tuple(tuple)
      end
  
    end # class Rename
  end # module Operator::Relational
end # module Alf
