module Alf
  module Operator
    module Relational
      class Union
        include Operator, Relational, Binary

        signature do |s|
        end

        def heading
          @heading ||= left.heading + right.heading
        end

      end # class Union
    end # module Relational
  end # module Operator
end # module Alf
