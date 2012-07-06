module Alf
  module Operator
    module Relational
      class Ungroup
        include Operator, Relational, Unary

        signature do |s|
          s.argument :attribute, AttrName, :grouped
        end

      end # class Ungroup
    end # module Relational
  end # module Operator
end # module Alf
