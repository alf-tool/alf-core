module Alf
  module Operator::NonRelational
    class Compact < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
      end

      def each(&block)
        Engine::Compact.new(input).each(&block)
      end

    end # class Compact
  end # module Operator::NonRelational
end # module Alf
