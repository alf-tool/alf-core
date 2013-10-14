module Alf
  class Predicate
    module Gte
      include DyadicComp

      def operator_symbol
        :>=
      end

    end
  end
end
