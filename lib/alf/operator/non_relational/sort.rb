module Alf
  module Operator::NonRelational
    class Sort < Alf::Operator()
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
