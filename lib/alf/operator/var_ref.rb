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
        @heading ||= relvar.heading
      end

      def keys
        @keys ||= relvar.keys
      end

      def each(&bl)
        context.connection.iterator(name).each(&bl)
      end

      def scope
        context.scope
      end

    private

      def relvar
        context.relvar(name)
      end

    end # class VarRef
  end # module Operator
end # module Operator
