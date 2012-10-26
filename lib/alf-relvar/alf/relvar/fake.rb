module Alf
  module Relvar
    class Fake
      include Relvar

      def initialize(heading)
        @heading = Heading.coerce(heading)
      end
      attr_reader :heading

      def insert(tuples)
        @inserted_tuples = tuples.to_a
      end
      attr_reader :inserted_tuples

      def delete(predicate = Predicate.tautology)
        @delete_predicate = predicate
      end
      attr_reader :delete_predicate

      def update(updating, predicate = Predicate.tautology)
        @updating = updating.to_hash
        @update_predicate = predicate
      end
      attr_reader :updating
      attr_reader :update_predicate

      def to_lispy
        "Relvar::Fake(#{heading.to_lispy})"
      end

    end # class Fake
  end # module
end # module Alf