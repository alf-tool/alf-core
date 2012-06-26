module Alf
  module Operator
    module Relational
      class Project
        include Operator, Relational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.option   :allbut,     Boolean,  false, 'Project all but specified attributes?'
        end

        # (see Operator#compile)
        def compile(context)
          op = Engine::Clip.new(operand, attributes, allbut, context)
          op = Engine::Compact.new(op, context)
          op
        end

      end # class Project
    end # module Relational
  end # module Operator
end # module Alf
