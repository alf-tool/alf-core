module Alf
  module Relvar
    class Virtual
      include Relvar

      # Inserts some tuples inside this relation variable.
      def insert(tuples)
        tuples = [ tuples ] if TupleLike===tuples
        Update::Inserter.new.call(expr, tuples)
      end

      # Updates all tuples of this relation variable.
      def update(computation, predicate = Predicate.tautology)
        Update::Updater.new.call(expr, computation, predicate)
      end

      # Delete all tuples of this relation variable.
      def delete(predicate = Predicate.tautology)
        Update::Deleter.new.call(expr, predicate)
      end

      ### to_xxx

      def to_s
        "Relvar::Virtual(#{expr})"
      end

    end # class Base
  end # module Relvar
end # module Alf
