module Alf
  module Operator
    module NonRelational
      class Generator
        include Operator, NonRelational, Nullary

        signature do |s|
          s.argument :size, Size, 10
          s.argument :as,   AttrName, :num
        end

        def heading
          @heading ||= Heading[as => Integer]
        end

        def keys
          @keys ||= Keys[ [as] ]
        end

      end # class Generator
    end # module NonRelational
  end # module Operator
end # module Alf
