module Alf
  module Operator
    #
    # Specialization of Operator for operators that simply convert single tuples 
    # to single tuples.
    #
    module Transform
      include Unary
  
      protected 
  
      # (see Operator#_each)
      def _each
        each_input_tuple do |tuple|
          yield _tuple2tuple(tuple)
        end
      end
  
      #
      # Transforms an input tuple to an output tuple
      #
      def _tuple2tuple(tuple)
      end
  
    end # module Transform
  end # module Operator
end # module Alf
