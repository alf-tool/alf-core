module Alf
  class Predicate
    module Neq
      include DyadicComp

      def operator_symbol
        :'!='
      end

    end
  end
end
