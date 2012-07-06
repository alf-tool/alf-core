module Alf
  module Operator
    module Relational
      class Rename
        include Operator, Relational, Unary

        signature do |s|
          s.argument :renaming, Renaming, {}
        end

      end # class Rename
    end # module Relational
  end # module Operator
end # module Alf
