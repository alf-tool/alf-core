module Alf
  module Relvar
    class Base
      include Relvar

      ### Update

      def lock(mode = :exclusive, &bl)
        connection!.lock(expr.name, mode, &bl)
      end

      def insert(tuples)
        tuples = [ tuples ] if TupleLike===tuples
        connection!.insert(expr.name, tuples)
      end

      def delete(predicate = Predicate.tautology)
        connection!.delete(expr.name, predicate)
      end

      def update(updating, predicate = Predicate.tautology)
        connection!.update(expr.name, updating, predicate)
      end

      def to_s
        "Relvar::Base(#{expr.name.inspect})"
      end

    end # class Base
  end # module Relvar
end # module Alf
