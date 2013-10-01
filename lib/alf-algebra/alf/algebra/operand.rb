module Alf
  module Algebra
    module Operand

      def self.coerce(op)
        case op
        when Operand     then op
        when Symbol      then Operand::Named.new(op)
        when Reader      then Proxy.new(op)
        when Array       then Proxy.new(op)
        when Engine::Cog then Proxy.new(op)
        when TupleLike   then Proxy.new([op])
        else
          who = op.inspect
          who = "#{who[0..20]}..." if who.size>20
          raise TypeError, "Invalid relational operand `#{who}`"
        end
      end

      ### Static analysis & inference

      def heading
        raise NotSupportedError, "Heading inference unsupported on `#{self}`"
      end

      def attr_list
        heading.to_attr_list
      end

      def keys
        raise NotSupportedError, "Key inference unsupported on `#{self}`"
      end

      ### to_xxx

      def to_cog
        raise NotSupportedError, "Compilation unsupported on `#{self}`"
      end

      def to_relation
        to_cog.to_relation
      end

      def to_dot(buffer = "")
        Algebra::ToDot.new.call(self, buffer)
      end

    end # module Operand
  end # module Algebra
end # module Alf
require_relative 'operand/fake'
require_relative 'operand/proxy'
require_relative 'operand/named'
