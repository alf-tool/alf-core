module Alf
  module Engine
    module Cog
      include Enumerable

      attr_reader :expr

      def initialize(expr)
        if expr && !expr.is_a?(Algebra::Operand)
          raise "Operand expected as first cog argument"
        end
        @expr = expr
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
