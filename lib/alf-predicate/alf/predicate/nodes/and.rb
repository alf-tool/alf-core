module Alf
  class Predicate
    module And
      include DyadicBool

      def operator_symbol
        :'&&'
      end

    end
  end
end
