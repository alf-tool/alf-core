module Alf
  module Relvar
    class ReadOnly
      extend Forwardable
      include Relvar

      def initialize(value)
        super(Algebra::Operand::Proxy.new(value))
      end

      def to_relation
        expr.subject
      end

      ### Update

      def lock(mode = :exclusive)
        yield
      end

      def insert(tuples)
        raise ReadOnlyError, "Unable to insert in read-only relation variables"
      end

      def delete(predicate = Predicate.tautology)
        raise ReadOnlyError, "Unable to delete in read-only relation variables"
      end

      def update(updating, predicate)
        raise ReadOnlyError, "Unable to update read-only relation variables"
      end

      ### to_xxx

      def to_s
        "Relvar::ReadOnly(#{value.to_s})"
      end

    end # class Base
  end # module Relvar
end # module Alf
