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
        def compile(context)
          Engine::Clip.new(operand, attributes, allbut, context)
        end

      end # class Clip
    end # module NonRelational
  end # module Operator
end # module Alf
