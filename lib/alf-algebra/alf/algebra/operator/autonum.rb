module Alf
  module Algebra
    class Autonum
      include Operator
      include NonRelational
      include Unary

      signature do |s|
        s.argument :as, AttrName, :autonum
      end

      def heading
        @heading ||= operand.heading + Heading[as => Integer]
      end

      def keys
        @keys ||= operand.keys + [ [ as ] ]
      end

    private

      def _type_check(options)
        no_name_clash!(operand.attr_list, AttrList[as])
      end

    end # class Autonum
  end # module Algebra
end # module Alf
