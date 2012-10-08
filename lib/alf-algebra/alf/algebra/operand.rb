module Alf
  module Algebra
    module Operand

      def self.coerce(op)
        case op
        when Operand     then op
        when Reader      then Proxy.new(op)
        when Array       then Proxy.new(op)
        when Engine::Cog then Proxy.new(op)
        else
          who = op.inspect
          who = "#{who[0..20]}..." if who.size>20
          raise TypeError, "Invalid relational operand `#{who}`"
        end
      end

      ### Static analysis & inference

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
require_relative 'operand/leaf'
require_relative 'operand/fake'
require_relative 'operand/proxy'
require_relative 'operand/named'
