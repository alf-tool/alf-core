module Alf
  module Operator
    module Relational
      class Project
        include Relational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.option   :allbut,     Boolean,  false, 'Project all but specified attributes?'
        end

        # (see Operator#compile)
        def compile
          op = Engine::Clip.new(operand, attributes, allbut)
          op = Engine::Compact.new(op)
          op
        end

      end # class Project
    end # module Relational
  end # module Operator
end # module Alf
