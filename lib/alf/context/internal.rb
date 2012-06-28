module Alf
  module Context
    #
    # Defines the internal, private contract seen by Alf's internals
    # on connections.
    #
    module Internal

      # Compiles a query expression given by a String or a block and returns the result
      # (typically a tuple iterator)
      #
      # Example
      #
      #   # with a string
      #   op = db.compile "(restrict :suppliers, lambda{ city == 'London' })"
      #
      #   # or with a block
      #   op = db.compile {
      #     (restrict :suppliers, lambda{ city == 'London' })
      #   }
      #
      # @param [String] expr a Lispy expression to compile
      # @return [Iterator] the iterator resulting from compilation
      def compile(expr = nil, path = nil, line = nil, &block)
        scope.evaluate(expr, path, line, &block)
      end

      # Returns an evaluation scope.
      #
      # @return [Scope] a scope instance on the global variables of the underlying database.
      def scope
        Lang::Lispy.new(context, @helpers)
      end

    end # module Internal
  end # module Context
end # module Alf