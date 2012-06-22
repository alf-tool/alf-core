module Alf
  module Operator
    module Relational
      class Rename
        include Relational, Unary

        signature do |s|
          s.argument :renaming, Renaming, {}
        end

        def compile(context)
          Engine::Rename.new(operand, renaming, context)
        end

      end # class Rename
    end # module Relational
  end # module Operator
end # module Alf
