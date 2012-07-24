module Alf
  module Operator
    class VarRef

      attr_reader :context
      attr_reader :name

      def initialize(context, name)
        @context = context
        @name = name
      end

      def heading
        @heading ||= context.relvar(name).heading
      end

    end # class VarRef
  end # module Operator
end # module Operator
