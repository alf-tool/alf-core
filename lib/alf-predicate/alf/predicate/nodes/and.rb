module Alf
  class Predicate
    module And
      include NadicBool

      def operator_symbol
        :'&&'
      end

      def and_split(attr_list)
        sexpr_body.inject([tautology, tautology]) do |(top,down),term|
          pair = term.and_split(attr_list)
          [top & pair.first, down & pair.last]
        end
      end

    end
  end
end
