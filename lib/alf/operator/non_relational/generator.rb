module Alf
  module Operator::NonRelational
    class Generator < Alf::Operator()
      include NonRelational, Nullary

      signature do |s|
        s.argument :size, Size, 10
        s.argument :as,   AttrName, :num
      end

      def each(&block)
        Engine::Generator.new(size, as, 1).each(&block)
      end

    end # class Generator
  end # module Operator::NonRelational
end # module Alf
