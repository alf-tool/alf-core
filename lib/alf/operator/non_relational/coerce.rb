module Alf
  module Operator::NonRelational
    class Coerce < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
        s.argument :heading, Heading, {}
      end

      def each(&block)
        Engine::Coerce.new(input, heading).each(&block)
      end

    end # class Coerce
  end # module Operator::NonRelational
end # module Alf
