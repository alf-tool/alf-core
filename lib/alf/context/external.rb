module Alf
  module Context
    #
    # Defines the external, public contract seen by users that obtain database
    # connections.
    #
    module External

      # Closes the connection, freeing unnecessary resources
      #
      # @return [undefined]
      def close
        adapter.close(self) if adapter
      end

      # Returns a relation variable either by name or a virtual relvar
      # corresponding to a query expression in `query`.
      #
      # Example:
      #
      #   # named relvar
      #   relvar = conn.relvar(:suppliers)
      #
      #   # query string
      #   relvar = conn.relvar "(restrict :suppliers, lambda{ city == 'London' })"
      #
      #   # or with a block
      #   relvar = conn.relvar {
      #     (restrict :suppliers, lambda{ city == 'London' })
      #   }
      #
      def relvar(expr = nil, path = nil, line = nil, &block)
        if block
          expr = compile(&block)
          Relvar::Virtual.new(context, nil, expr)
        elsif expr.is_a?(String)
          expr = compile(expr, path, line)
          Relvar::Virtual.new(context, nil, expr)
        elsif expr.is_a?(Symbol)
          adapter.relvar(expr)
        else
          raise ArgumentError, "Invalid relvar name `#{expr}`"
        end
      end

      # Evaluates a query expression given by a String or a block and returns
      # the result as an in-memory relation (Alf::Relation)
      #
      # Example:
      #
      #   # with a string
      #   rel = conn.evaluate "(restrict :suppliers, lambda{ city == 'London' })"
      #
      #   # or with a block
      #   rel = conn.evaluate {
      #     (restrict :suppliers, lambda{ city == 'London' })
      #   }
      #
      def evaluate(expr = nil, path = nil, line = nil, &block)
        c = compile(expr, path, line, &block)
        c.respond_to?(:to_relation) ? c.to_relation : c
      end
      alias :query :evaluate

    end # module External
  end # module Context
end # module Alf