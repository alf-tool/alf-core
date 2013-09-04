module Alf
  module Relvar
    class Base
      include Relvar

      def initialize(expr)
        raise "Named operand expected, got `#{expr}`" unless expr.is_a?(Algebra::Operand::Named)
        @expr = expr
      end
      attr_reader :expr

      ### Relvar contract

      def name
        expr.name
      end

      ### Static analysis & inference

      def heading
        connection!.heading(name)
      end

      def keys
        connection!.keys(name)
      end

      ### Update

      def lock(mode = :exclusive, &bl)
        connection!.lock(name, mode, &bl)
      end

      def insert(tuples)
        tuples = [ tuples ] if TupleLike===tuples
        connection!.insert(name, tuples)
      end

      def delete(predicate = Predicate.tautology)
        connection!.delete(name, predicate)
      end

      def update(updating, predicate = Predicate.tautology)
        connection!.update(name, updating, predicate)
      end

      ### to_xxx

      def to_cog
        connection!.cog(name, self)
      end

      def to_lispy
        name.to_s
      end

      def to_s
        "Relvar::Base(#{name.inspect})"
      end

    private

      def _self_operand
        self
      end

    end # class Base
  end # module Relvar
end # module Alf
