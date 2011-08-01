module Alf
  module Types
    # 
    # Encapsulates a tuple computation from other tuples expressions
    #
    class TupleComputation
      
      # @return [Hash] a computation hash, mapping AttrName -> TupleExpression
      attr_reader :computation
      
      #
      # Creates a TupleComputation instance
      #
      # @param [Hash] computation, a mappping AttrName -> TupleExpression
      #
      def initialize(computation)
        @computation = computation
      end
      
      # 
      # Coerces `arg` to a tuple computation
      #
      def self.coerce(arg)
        case arg
        when TupleComputation
          arg
        when Hash
          h = Tools.tuple_collect(arg){|k,v|
            if AttrName === k
              v = TupleExpression.coerce(v) if v.is_a?(Proc)
              [k, v] 
            else
              [Tools.coerce(k, AttrName), Tools.coerce(v, TupleExpression)]
            end
          }
          TupleComputation.new(h)
        when Array
          coerce(Hash[*arg])
        else
          raise ArgumentError, "Invalid argument `arg` for TupleComputation()"
        end
      end
      
      # Coerce from ARGV
      def self.from_argv(argv, opts = {})
        coerce(argv)
      end
      
      #
      # Computes the result, given `tuple` as context and `handle` to
      # evaluate expressions. 
      #
      def evaluate(obj = nil)
        Tools.tuple_collect(@computation){|k,v| 
          [k, v.is_a?(TupleExpression) ? v.evaluate(obj) : v]
        }
      end
      
    end # class TupleComputation
  end # module Types
end # module Alf