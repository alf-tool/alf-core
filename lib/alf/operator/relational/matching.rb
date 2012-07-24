module Alf
  module Operator
    module Relational
      class Matching
        include Operator, Relational, Binary

        signature do |s|
        end

        def heading
          @heading ||= left.heading
        end

      end # class Matching
    end # module Relational
  end # module Operator
end # module Alf
