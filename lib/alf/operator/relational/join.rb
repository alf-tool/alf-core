module Alf
  module Operator
    module Relational
      class Join
        include Operator, Relational, Binary

        signature do |s|
        end

        def heading
          @heading ||= left.heading + right.heading
        end

      end # class Join
    end # module Relational
  end # module Operator
end # module Alf
