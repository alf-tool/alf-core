module Alf
  module Operator::Relational
    class Rename < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :renaming, Renaming, {}
      end

      def each(&block)
        Engine::Rename.new(input, renaming).each(&block)
      end

    end # class Rename
  end # module Operator::Relational
end # module Alf
