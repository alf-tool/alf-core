module Alf
  module Operator
    module Relational
      class Wrap
        include Operator, Relational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.argument :as, AttrName, :wrapped
        end

      end # class Wrap
    end # module Relational
  end # module Operator
end # module Alf
