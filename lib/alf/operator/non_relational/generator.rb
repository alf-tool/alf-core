module Alf
  module Operator::NonRelational
    class Generator < Alf::Operator()
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
  end # module Operator::NonRelational
end # module Alf
