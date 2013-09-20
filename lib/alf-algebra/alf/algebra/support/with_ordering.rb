module Alf
  module Algebra
    module WithOrdering

      def total_ordering
        ordering.total(keys){ heading }
      end

    end # module WithOrdering
  end # module Algebra
end # module Alf
