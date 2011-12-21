module Alf
  module Operator
    module NonRelational
      class Generator
        include NonRelational, Nullary

        signature do |s|
          s.argument :size, Size, 10
          s.argument :as,   AttrName, :num
        end

        # (see Operator#compile)
        def compile
          Engine::Generator.new(as, 1, 1, size)
        end

      end # class Generator
    end # module NonRelational
  end # module Operator
end # module Alf
