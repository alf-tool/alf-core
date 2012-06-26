module Alf
  module Operator
    module Relational
      class Join
        include Operator, Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Join::Hash.new(left, right, context)
        end

      end # class Join
    end # module Relational
  end # module Operator
end # module Alf
