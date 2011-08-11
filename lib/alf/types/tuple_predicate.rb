module Alf
  module Types
    # 
    # Specialization of TupleExpression to boolean expressions 
    # specifically
    #
    class TuplePredicate < TupleExpression
      
      # 
      # Coerces `arg` to a TuplePredicate
      #
      def self.coerce(arg)
        case arg
        when TuplePredicate
          arg
        when TupleExpression
          TuplePredicate.new arg.expr_lambda, arg.source
        when TrueClass, FalseClass
          TuplePredicate.new lambda{ arg }, arg.to_s
        when Proc
          TuplePredicate.new arg, nil
        when String, Symbol
          l = eval("lambda{ #{arg} }")
          TuplePredicate.new l, arg.to_s
        when Hash
          h = Tools.tuple_collect(arg){|k,v|
            (AttrName === k) ? 
              [k,v] : [Tools.coerce(k, AttrName), Kernel.eval(v)]
          }
          source = h.each_pair.collect{|k,v|
            "(self.#{k} == #{Tools.to_ruby_literal(v)})"
          }.join(" && ")
          coerce(source.empty? ? true : source)
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
      
    end # class TuplePredicate
  end # module Types
end # module Alf
