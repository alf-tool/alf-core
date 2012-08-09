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

        def keys
          @keys ||= (left.keys + right.keys.select{|k| k.subset?(common_attributes) })
        end

      end # class Matching
    end # module Relational
  end # module Operator
end # module Alf
