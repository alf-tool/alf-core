module Alf
  module Relvar
    class ReadOnly
      include Relvar

      def initialize(value)
        @value = value
      end
      attr_reader :value

      ### Static analysis & inference

      def heading
        value.heading
      end

      def keys
        value.keys
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

      alias_method :to_relation, :value

      def to_cog
        value.to_cog
      end

      def to_lispy
        value.to_lispy
      end

      def to_s
        "Relvar::ReadOnly(#{value.to_s})"
      end

    private

      def _self_operand
        value
      end

    end # class Base
  end # module Relvar
end # module Alf
