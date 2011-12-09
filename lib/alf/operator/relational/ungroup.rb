module Alf
  module Operator::Relational
    class Ungroup < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :attribute, AttrName, :grouped
      end

      # (see Operator#compile)
      def compile
        Engine::Ungroup.new(operand, attribute)
      end

    end # class Ungroup
  end # module Operator::Relational
end # module Alf
