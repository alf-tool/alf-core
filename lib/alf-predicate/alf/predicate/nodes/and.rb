module Alf
  class Predicate
    module And
      include NadicBool

      def operator_symbol
        :'&&'
      end

    end
  end
end
