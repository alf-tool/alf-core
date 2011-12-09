module Alf
  module Operator::NonRelational
    class Autonum < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
        s.argument :as, AttrName, :autonum
      end

      # (see Operator#compile)
      def compile
        Engine::Autonum.new(operand, as)
      end

    end # class Autonum
  end # module Operator::NonRelational
end # module Alf
