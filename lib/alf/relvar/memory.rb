module Alf
  class Relvar
    #
    # A Relvar whose value simply fits as a Relation in memory.
    #
    class Memory < Relvar

      # Creates a memory relvar instance.
      #
      # @param [Object] context the context that served this relvar.
      # @param [Symbol] name name of the relation variable.
      def initialize(context, init_value = Alf::Relation::DUM)
        super(context, nil)
        @value = init_value
      end

      # (see Relvar#affect)
      def affect(tuples)
        @value = Tools.to_relation(tuples)
      end

      # (see Relvar#insert)
      def insert(tuples)
        tuples   = [ tuples ] if tuples.is_a?(Hash)
        existing = self
        @value   = context.query{ union(existing, tuples) }
      end

      # (see Relvar#delete)
      def delete
        @value = Alf::Relation::DUM
      end

    protected

      def _compile
        @value
      end

    end # class Memory
  end # class Relvar
end # module Alf