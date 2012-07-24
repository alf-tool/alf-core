module Alf
  module Context
    #
    # Defines the internal, private contract seen by Alf's internals
    # on connections.
    #
    module Internal

      # Returns an evaluation scope.
      #
      # @return [Scope] a scope instance on the global variables of the underlying database.
      def scope
        Lang::Lispy.new(context, @helpers)
      end

    end # module Internal
  end # module Context
end # module Alf