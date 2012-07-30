module Alf
  module Operator
    class VarRef
      include Iterator

      attr_reader :context
      attr_reader :name

      def initialize(context, name)
        @context = context
        @name = name
      end

      def heading
        @heading ||= context.connection.heading(name)
      end

      def keys
        @keys ||= context.connection.keys(name)
      end

      def each(&bl)
        context.connection.iterator(name).each(&bl)
      end

      def scope
        context.scope
      end

    end # class VarRef
  end # module Operator
end # module Operator
