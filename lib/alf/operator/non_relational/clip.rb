module Alf
  module Operator
    module NonRelational
      class Clip
        include Operator, NonRelational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.option   :allbut,     Boolean, false, "Apply an allbut clipping?"
        end

      end # class Clip
    end # module NonRelational
  end # module Operator
end # module Alf
