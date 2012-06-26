module Alf
  module Context
    #
    # Defines the internal, private contract seen by Alf's internals
    # on connections.
    #
    module Internal

      # Logical adapter
      attr_reader :adapter

      # Creates a database instance, using `adapter` as logical
      # adapter.
      def initialize(adapter = nil, helpers = [])
        super()
        @adapter = adapter
        @helpers = helpers
      end

      # Returns a dataset whose name is provided.
      #
      # This method resolves named datasets to tuple enumerables by passing the request to
      # the lower stage. When the dataset exists, this method must return an Iterator.
      # Otherwise, it throws a NoSuchDatasetError.
      #
      # @param [Symbol] name the name of a dataset
      # @return [Iterator] an iterator
      # @raise [NoSuchDatasetError] when the dataset does not exists
      def dataset(name)
        adapter.dataset(name)
      end

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