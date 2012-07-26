module Alf
  module Operator
    module Relational
      class Minus
        include Operator, Relational, Binary

        signature do |s|
        end

        def heading
          @heading ||= left.heading
        end

        def keys
          @keys ||= left.keys
        end

      end # class Minus
    end # Relational
  end # module Operator
end # module Alf
