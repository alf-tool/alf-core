module Alf
  module Operator
    module NonRelational
      class Clip
        include NonRelational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.option   :allbut,     Boolean, false, "Apply an allbut clipping?"
        end

        # (see Operator#compile)
        def compile
          Engine::Clip.new(operand, attributes, allbut)
        end

      end # class Clip
    end # module NonRelational
  end # module Operator
end # module Alf
