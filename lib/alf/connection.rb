module Alf
  class Connection

    # Logical adapter
    attr_reader :adapter

    # Scope helpers
    attr_reader :helpers

    # Creates a database instance, using `adapter` as logical
    # adapter.
    def initialize(adapter = nil, helpers = [])
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
      @adapter.dataset(name)
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
      lispy.evaluate(expr, path, line, &block)
    end

    # Evaluates a query expression given by a String or a block and returns
    # the result as an in-memory relation (Alf::Relation)
    #
    # Example:
    #
    #   # with a string
    #   rel = evaluate "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   rel = evaluate {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    def evaluate(expr = nil, path = nil, line = nil, &block)
      c = compile(expr, path, line, &block)
      c.respond_to?(:to_relation) ? c.to_relation : c
    end
    alias :query :evaluate

    # Returns an evaluation scope.
    #
    # @return [Scope] a scope instance on the global variables of the underlying database.
    def lispy
      Lang::Lispy.new(self, helpers)
    end
    alias :scope :lispy

  end # class Connection
end # module Alf