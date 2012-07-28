module Alf
  class Predicate
    module Gt
      include DyadicComp

      def operator_symbol
        :>
      end

    end
  end
end
