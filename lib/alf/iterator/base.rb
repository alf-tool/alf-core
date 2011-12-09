module Alf
  module Iterator
    module Base

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
