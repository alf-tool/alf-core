module Alf
  class Predicate
    module Or
      include DyadicBool

      def operator_symbol
        :'||'
      end

    end
  end
end
