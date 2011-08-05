module Alf
  module Operator::Relational
    class Minus < Alf::Operator()
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature do |s|
      end
      
      class HashBased
        include Operator, Operator::Binary
      
        protected
        
        def _prepare
          @index = Hash.new
          right.each{|t| @index[t] = true}
        end
        
        def _each
          left.each do |left_tuple|
            yield(left_tuple) unless @index.has_key?(left_tuple)
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Minus
  end # module Operator::Relational
end # module Alf
