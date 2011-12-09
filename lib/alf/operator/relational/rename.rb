module Alf
  module Operator::Relational
    class Rename < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :renaming, Renaming, {}
      end

      def compile
        Engine::Rename.new(operand, renaming)
      end

    end # class Rename
  end # module Operator::Relational
end # module Alf
