module Alf
  module Algebra
    class Allbut
      include Shortcut
      include Unary

      signature do |s|
        s.argument :attributes, AttrList, []
      end

      def expand
        project(operand, attributes, allbut: true)
      end

      def key_preserving?
        expand.key_preserving?
      end

      def stay_attributes
        expand.stay_attributes
      end

    end # class Allbut
  end # module Algebra
end # module Alf
