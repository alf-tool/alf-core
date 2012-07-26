module Alf
  class Adapter
    #
    # Defines the internal, private contract seen by Alf's internals
    # on connections.
    #
    module Internal

      # The connection specification
      attr_reader :conn_spec

      # Creates an adapter instance, wired to the specified folder.
      #
      # @param [String] folder path to the folder to use as dataset source.
      def initialize(conn_spec, scope_helpers = [ Lang::Functional ])
        @scope_helpers = scope_helpers
        @conn_spec     = conn_spec
      end

      # Returns an evaluation scope.
      #
      # @return [Scope] a scope instance on the global variables of the underlying database.
      def scope
        Lang::Lispy.new(self, @scope_helpers)
      end

    end # module Internal
  end # class Adapter
end # module Alf