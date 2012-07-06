module Alf
  module Operator
    module NonRelational
      class Autonum
        include Operator, NonRelational, Unary

        signature do |s|
          s.argument :as, AttrName, :autonum
        end

      end # class Autonum
    end # module NonRelational
  end # module Operator
end # module Alf
