module Alf
  module Operator::Relational
    class Wrap < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.argument :as, AttrName, :wrapped
      end

      # (see Operator#compile)
      def compile
        Engine::Wrap.new(operand, attributes, as, false)
      end

    end # class Wrap
  end # module Operator::Relational
end # module Alf
