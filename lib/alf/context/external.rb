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

      # Parses a query expression given by a String or a block and returns the
      # resulting AST
      #
      # Example
      #
      #   # with a string
      #   op = db.parse "(restrict :suppliers, lambda{ city == 'London' })"
      #
      #   # or with a block
      #   op = db.parse {
      #     (restrict :suppliers, lambda{ city == 'London' })
      #   }
      #
      # @param [String] expr a Lispy expression to compile
      # @return [Object] The AST resulting from the parsing
      def parse(expr = nil, path = nil, line = nil, &block)
        if expr && block
          raise ArgumentError, "Either `expr` or `block` should be specified"
        elsif block or expr.is_a?(String)
          expr = scope.evaluate(expr, path, line, &block)
        end
        expr = Operator::VarRef.new(self, expr) if expr.is_a?(Symbol)
        expr
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
          expr = parse(&block)
          Relvar::Virtual.new(context, nil, expr)
        elsif expr.is_a?(String)
          expr = parse(expr, path, line)
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
      def query(expr = nil, path = nil, line = nil, &block)
        expr = parse(expr, path, line, &block)
        cog  = Engine::Compiler.new(self).compile(expr)
        Tools.to_relation(cog)
      end

    end # module External
  end # module Context
end # module Alf
