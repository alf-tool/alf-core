module Alf
  class Predicate
    module Lte
      include DyadicComp

      def operator_symbol
        :<=
      end

    end
  end
end
