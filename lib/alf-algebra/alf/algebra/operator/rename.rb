module Alf
  module Algebra
    class Rename
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :renaming, Renaming, {}
      end

      def heading
        @heading ||= operand.heading.rename(renaming)
      end

      def keys
        @keys ||= operand.keys.rename(renaming)
      end

      def complete_renaming
        renaming.complete(operand.heading.to_attr_list)
      end

    end # class Rename
  end # module Algebra
end # module Alf
