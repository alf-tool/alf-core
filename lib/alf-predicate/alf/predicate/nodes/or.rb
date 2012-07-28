module Alf
  class Predicate
    module Or
      include NadicBool

      def operator_symbol
        :'||'
      end

    end
  end
end
