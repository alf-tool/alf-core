module Alf
  class Predicate
    module Lt
      include DyadicComp

      def operator_symbol
        :<
      end

    end
  end
end
