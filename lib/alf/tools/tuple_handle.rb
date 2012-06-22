module Alf
  module Tools
    #
    # Provides a handle for implementing a flyweight design pattern on tuples.
    #
    # This class works hand-in-hand with TupleExpression as it provides a scope
    # for their evaluation on tuples.
    #
    # Example:
    #
    #   handle = TupleHandle.new
    #   expr   = TupleExpression["status > 10"]
    #   relation.each do |tuple|
    #     expr.evaluate(handle.set(tuple))
    #   end
    #
    class TupleHandle < Scope

      module OwnMethods

        # Returns true if the decorated tuple has `name` as key.
        def respond_to?(name)
          return true if @tuple && @tuple.has_key?(name)
          super
        end

        # Sets the next tuple to use.
        #
        # On first call, this method installs the handle as a side effect.
        #
        # @param [Tuple] tuple the current iterated tuple
        # @return [TupleHandle] self
        def __set_tuple(tuple)
          __build(tuple) if @tuple.nil?
          @tuple = tuple
          self
        end

        # Builds this handle with a tuple.
        #
        # This method should be called only once and installs instance methods on
        # the handle with keys of _tuple_.
        def __build(tuple)
          tuple.keys.each do |k|
            (class << self; self; end).send(:define_method, k) do
              @tuple[k]
            end
          end
          self
        end

      end # module OwnMethods

      # Creates a handle instance
      def initialize(tuple = nil, extensions = [])
        super [ OwnMethods ] + extensions
        __build(@tuple = tuple) if tuple
      end

    end # class TupleHandle
  end # module Tools
end # module Alf
