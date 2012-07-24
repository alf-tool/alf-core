module Alf
  module Operator
    module Relational
      class Rank
        include Operator, Relational, Unary

        signature do |s|
          s.argument :order, Ordering, []
          s.argument :as, AttrName, :rank
        end

        def heading
          @heading ||= operand.heading.merge(as => Integer)
        end

      end # class Rank
    end # module Relational
  end # module Operator
end # module Alf
