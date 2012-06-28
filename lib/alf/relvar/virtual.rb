module Alf
  class Relvar
    #
    # A virtual relation variable, aka a view.
    #
    class Virtual < Relvar

      # Expression in algebra expression for this view.
      attr_reader :expression

      # Creates a relvar instance.
      #
      # @param [Object] context the context that served this relvar.
      # @param [Symbol] name name of the relation variable.
      def initialize(context, name = nil, expression=nil, &defn)
        super(context, name)
        @expression = expression || context.compile(&defn)
      end

    protected

      # Ask the expression to compile itself.
      def compile(context)
        expression.compile(context)
      end

    private

      def _operator_output(op)
        Relvar::Virtual.new(context, nil, op)
      end

      def _self_operand
        expression
      end

    end # class Virtual
  end # class Relvar
end # module Alf