module Alf
  module Iterator
    module Base

      #
      # Wire the iterator input and an optional execution environment.
      #
      # Iterators (typically Reader and Operator instances) work from input data 
      # that come from files, or other operators, and so on. This method wires 
      # this input data to the iterator. Wiring is required before any attempt
      # to call each, unless autowiring occurs at construction. The exact kind of
      # input object is left at discretion of Iterator implementations.
      #
      # @param [Object] input the iterator input, at discretion of the Iterator
      #        implementation.
      # @param [Environment] environment an optional environment for resolving
      #        named datasets if needed.
      # @return [Object] self
      #
      def pipe(input, environment = nil)
        self
      end
      undef :pipe
      
      #
      # Converts this iterator to an in-memory Relation.
      #
      # @return [Relation] a relation instance, as the set of tuples
      #         that would be yield by this iterator.
      #
      def to_rel
        Relation::coerce(self)
      end

    end # module Base
    include(Base)
  end # module Iterator
end # module Alf
