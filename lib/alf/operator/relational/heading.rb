module Alf
  module Operator::Relational
    class Heading < Alf::Operator()
      include Operator::Relational, 
              Operator::Unary
    
      signature do |s|
      end
      
      protected 
    
      # See Operator#_prepare
      def _prepare
        @tuple_heading = nil
        each_input_tuple do |tuple|
          h = tuple_heading(tuple)
          @tuple_heading ||= h
          @tuple_heading += h
        end
      end

      # See Operator#_each
      def _each
        yield(@tuple_heading.attributes)
      end

    end # class Project
  end # module Operator::Relational
end # module Alf
