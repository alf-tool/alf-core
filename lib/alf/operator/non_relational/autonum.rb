module Alf
  module Operator::NonRelational
    class Autonum < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
        s.argument :as, AttrName, :autonum
      end

      def each(&block)
        Engine::Autonum.new(input, as).each(&block)
      end

    end # class Autonum
  end # module Operator::NonRelational
end # module Alf
