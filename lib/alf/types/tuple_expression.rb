module Alf
  module Types
    #
    # Encapsulates the notion of tuple expression, which is a Ruby expression
    # whose evaluates in the context and scope of a specific tuple.
    #
    class TupleExpression
      
      # @return [Proc] the lambda expression
      attr_reader :expr_lambda
      
      # @return [String] the expression source code 
      attr_reader :source
      
      #
      # Creates a tuple expression from a Proc object
      #
      # @param [Proc] expr a Proc for the expression 
      #
      def initialize(expr, source = nil)
        @expr_lambda = expr
        @source = source
      end
      
      # 
      # Coerces `arg` to a tuple expression
      # 
      def self.coerce(arg)
        case arg
        when TupleExpression
          arg
        when Proc
          TupleExpression.new(arg, nil)
        when String, Symbol
          lamb = eval("lambda{ #{arg} }")
          TupleExpression.new(lamb, arg.to_s)
        else
          raise ArgumentError, "Invalid argument `#{arg}` for TupleExpression()"
        end
      end

      # Coerces from ARGV 
      def self.from_argv(argv, options = {})
        raise ArgumentError if argv.size > 1
        coerce(argv.first || options[:default])
      end

      #
      # Evaluates in the context of obj
      #
      def evaluate(obj = nil)
        if RUBY_VERSION < "1.9"
          obj.instance_eval(&@expr_lambda)
        else
          obj.instance_exec(&@expr_lambda)
        end
      end
      
    end # class TupleExpression
  end # module Types
end # module Alf
