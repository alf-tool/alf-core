module Alf
  module Operator::NonRelational
    class Compact < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
      end

      # (see Operator#compile)
      def compile
        Engine::Compact.new(operand)
      end

    end # class Compact
  end # module Operator::NonRelational
end # module Alf
