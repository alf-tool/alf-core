module Alf
  module Support
    #
    # Specialization of Scope for working on a tuple specifically.
    #
    # This class works hand-in-hand with TupleExpression as it provides a scope for their
    # evaluation on tuples. It also provides a handle for implementing a flyweight design
    # pattern on tuples through the `__set_tuple` method.
    #
    # Example:
    #
    #   scope = TupleScope.new
    #   expr  = TupleExpression["status > 10"]
    #   relation.each do |tuple|
    #     expr.evaluate(scope.__set_tuple(tuple))
    #   end
    #
    class TupleScope < Scope

      module OwnMethods

        # Returns true if the decorated tuple has `name` as key.
        def respond_to?(name)
          return true if @tuple && @tuple.has_key?(name)
          super
        end

        # Sets the next tuple to use.
        #
        # On first call, this method installs the scope as a side effect unless a tuple
        # has already been provided at construction.
        #
        # @param [Tuple] tuple the current iterated tuple
        # @return [TupleScope] self
        def __set_tuple(tuple)
          __build(tuple) if @tuple.nil?
          @tuple = tuple
          self
        end

        # Builds this scope with a tuple.
        #
        # This method should be called only once and installs instance methods on
        # the scope with keys of _tuple_.
        def __build(tuple)
          tuple.keys.each do |k|
            (class << self; self; end).send(:define_method, k) do
              @tuple[k]
            end
          end
          self
        end

        def query
          @parent.query(yield)
        end

      end # module OwnMethods

      # Creates a scope instance
      def initialize(tuple = nil, extensions = [], parent = nil)
        super [ OwnMethods ] + extensions, parent
        __build(@tuple = tuple) if tuple
      end

    end # class TupleScope
  end # module Support
end # module Alf
