module Alf
  module Algebra
    module WithOrdering

      def full_ordering
        selectors = ordering.selectors
        if keys.any?{|key| key.subsetOf?(selectors) }
          ordering
        elsif key = keys.first
          ordering.merge(key.to_ordering){|a,d1,d2| d1 }
        else
          ordering.merge(heading.to_attr_list.to_ordering){|a,d1,d2| d1 }
        end
      end

    end # module WithOrdering
  end # module Algebra
end # module Alf
