module Alf
  module Relvar
    class Memory
      include Relvar

      def initialize(value)
        unless value.is_a?(Algebra::Operand)
          value = Algebra::Operand.coerce(value)
        end
        super(value)
      end

      def to_relation
        expr.to_relation
      end

      ### Update

      def lock(mode = :exclusive)
        yield
      end

      def affect(value)
        @expr = Relation(value)
      end

      def insert(tuples)
        affect(value.union(Relation(tuples)))
      end

      def delete(predicate = Predicate.tautology)
        predicate = Predicate.coerce(predicate)
        affect(value.restrict(!predicate))
      end

      def update(updating, predicate)
        predicate = Predicate.coerce(predicate)
        affect(value.restrict(!predicate).union(value.extend(updating)))
      end

      ### to_xxx

      def to_s
        "Relvar::Memory(#{value.to_s})"
      end

    end # class Memory
  end # module Relvar
end # module Alf
