module Alf
  module Relvar
    class Base
      include Relvar

      def initialize(name, connection = nil)
        raise unless name.is_a?(Symbol)
        @name = name
        @connection = connection
      end
      attr_reader :name

      ### Static analysis & inference

      def heading
        connection!.heading(name)
      end

      def keys
        connection!.keys(name)
      end

      ### Update

      def insert(tuples)
        tuples = [ tuples ] if TupleLike===tuples
        connection!.insert(name, tuples)
      end

      def delete(predicate = Predicate.tautology)
        connection!.delete(name, predicate)
      end

      def update(updating, predicate)
        connection!.update(name, updating, predicate)
      end

      ### to_xxx

      def to_cog
        connection!.cog(name)
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
