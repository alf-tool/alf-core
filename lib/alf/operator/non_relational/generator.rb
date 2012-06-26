module Alf
  module Operator
    module NonRelational
      class Generator
        include Operator, NonRelational, Nullary

        signature do |s|
          s.argument :size, Size, 10
          s.argument :as,   AttrName, :num
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Generator.new(as, 1, 1, size, context)
        end

      end # class Generator
    end # module NonRelational
  end # module Operator
end # module Alf
