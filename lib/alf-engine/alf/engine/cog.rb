module Alf
  module Engine
    module Cog
      include Enumerable

      def to_relation
        Relation.coerce(to_a)
      end

      def each(&bl)
        return to_enum unless block_given?
        _each(&bl)
      end

    protected

      def tuple_scope(tuple = nil)
        Support::TupleScope.new tuple, []
      end

    end # module Cog
  end # module Engine
end # module Alf
