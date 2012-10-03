module Alf
  module Algebra
    module Operand

      def heading
        raise NotSupportedError
      end

      def attr_list
        heading.to_attr_list
      end

      def keys
        raise NotSupportedError
      end

    end # module Operand
  end # module Algebra
end # module Alf
require_relative 'operand/fake'
require_relative 'operand/proxy'
