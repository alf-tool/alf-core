module Alf
  module Engine
    module Cog
      include Enumerable

      attr_reader :expr
      attr_reader :compiler

      def initialize(expr, compiler = nil)
        if expr && !expr.is_a?(Algebra::Operand)
          raise "Operand expected as first cog argument"
        end
        @expr = expr
        @compiler = compiler
      end

      def heading
        return expr.heading if expr
        raise NotSupportedError, "Cog#heading without expr traceability"
      end

      def keys
        return expr.keys if expr
        raise NotSupportedError, "Cog#keys without expr traceability"
      end

      def cog_orders
        []
      end

      def orderedby?(order)
        cog_orders.any?{|o| order <= o }
      end

      def to_cog
        self
      end

      def to_relation
        Relation.coerce(to_a)
      end

      def each(&bl)
        return to_enum unless block_given?
        _each(&bl)
      end

      def to_dot(buffer = "")
        Engine::ToDot.new.call(self, buffer)
      end

    protected

      def tuple_scope(tuple = nil)
        Support::TupleScope.new tuple, []
      end

    end # module Cog
  end # module Engine
end # module Alf
