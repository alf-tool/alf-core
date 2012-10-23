module Alf
  module Lang
    module Functional

      class << self
        def def_aggregator_method(name, clazz)
          define_method(name) do |*args, &block|
            clazz.new(*args, &block)
          end
        end

        def def_operator_method(name, clazz)
          define_method(name) do |*args|
            operands, arguments = args[0...clazz.arity], args[clazz.arity..-1]
            _op_wrap clazz.new(operands.map{|op| _op_unwrap(op) }, *arguments)
          end
        end
      end

      def Heading(*args, &bl)
        Alf::Heading(*args, &bl)
      end

      def Tuple(*args, &bl)
        Alf::Tuple(*args, &bl)
      end

      def Relation(*args, &bl)
        Alf::Relation(*args, &bl)
      end

      Aggregator.listen do |name, clazz|
        def_aggregator_method(name, clazz)
      end

      Algebra::Operator.listen do |name, clazz|
        def_operator_method(name, clazz)
      end

      def allbut(operand, attributes)
        project(operand, attributes, :allbut => true)
      end

    private

      def _op_wrap(expr)
        expr
      end

      def _op_unwrap(expr)
        expr
      end

    end
  end
end
