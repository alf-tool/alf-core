module Alf
  class Connection
    #
    # Defines the internal, private contract seen by Alf's internals
    # on connections.
    #
    module Internal

      # The connection specification
      attr_reader :conn_spec

      # Creates an connection instance, wired to the specified folder.
      #
      # @param [String] folder path to the folder to use as dataset source.
      def initialize(conn_spec, scope_helpers = [ Lang::Functional ])
        @scope_helpers = scope_helpers
        @conn_spec     = conn_spec
      end

      # Returns an optimizer instance
      def optimizer
        Optimizer.new(self).
                  register(Optimizer::Restrict.new, Operator::Relational::Restrict)
      end

      # Returns a compiler instance
      def compiler
        Engine::Compiler.new(self)
      end

      # Returns a low-level Iterator for a given named variable
      def iterator(name)
        raise NotImplementedError, "Unable to serve `#{name}` in Connection.iterator"
      end

      # Returns the heading of a given named variable
      def heading(name)
        raise NotSupportedError, "Unable to infer heading for `#{name}`"
      end

      # Returns the keys of a given named variable
      def keys(name)
        raise NotSupportedError, "Unable to infer keys for `#{name}`"
      end

      # Returns an evaluation scope.
      #
      # @return [Scope] a scope instance on the global variables of the underlying database.
      def scope
        Lang::Lispy.new(self, @scope_helpers)
      end

    end # module Internal
  end # class Connection
end # module Alf