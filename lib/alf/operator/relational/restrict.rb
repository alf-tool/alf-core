module Alf
  module Operator::Relational
    class Restrict < Alf::Operator()
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
