module Alf
  module Types
    # 
    # Specialization of TupleExpression to boolean expressions 
    # specifically
    #
    class Restriction < TupleExpression
      
      # 
      # Coerces `arg` to a Restriction
      #
      def self.coerce(arg)
        case arg
        when Restriction
          arg
        when TrueClass, FalseClass
          Restriction.new lambda{ arg }
        when TupleExpression, Proc, String, Symbol
          Restriction.new TupleExpression.coerce(arg).expr_lambda
        when Hash
          if arg.empty?
            coerce(true)
          else
            h = Tools.tuple_collect(arg){|k,v|
              (AttrName === k) ? 
                [k,v] : [Tools.coerce(k, AttrName), Kernel.eval(v)]
            }
            coerce h.each_pair.collect{|k,v|
              "(self.#{k} == #{Tools.to_ruby_literal(v)})"
            }.join(" && ")
          end
        when Array
          (arg.size <= 1) ?
            coerce(arg.first || true) :
            coerce(Hash[*arg])
        else
          raise ArgumentError, "Invalid argument `#{arg}` for TupleExpression()"
        end
      end
      
      def self.from_argv(argv)
        coerce(argv)
      end
      
    end # class Restriction
  end # module Types
end # module Alf