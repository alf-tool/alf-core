module Alf
  module Relvar
    class Base
      include Relvar

      ### Relvar contract

      def name
        expr.name
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

      def to_s
        "Relvar::Base(#{expr.name.inspect})"
      end

    end # class Base
  end # module Relvar
end # module Alf
