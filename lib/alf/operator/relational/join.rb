module Alf
  module Operator
    module Relational
      class Join
        include Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile
          Engine::Join::Hash.new(left, right)
        end

      end # class Join
    end # module Relational
  end # module Operator
end # module Alf
