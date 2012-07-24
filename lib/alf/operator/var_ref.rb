module Alf
  module Operator
    class VarRef

      attr_reader :context
      attr_reader :name

      def initialize(context, name)
        @context = context
        @name = name
      end

      def info
        context.info(name)
      end

    end # class VarRef
  end # module Operator
end # module Operator
