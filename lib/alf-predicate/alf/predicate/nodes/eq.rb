module Alf
  class Predicate
    module Eq
      include DyadicComp

      def operator_symbol
        :==
      end

    end
  end
end
