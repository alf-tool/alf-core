module Alf
  class Connection
    #
    # Defines the external, public contract seen by users that obtain database
    # connections.
    #
    module External

      # Closes this connection, freeing resources if needed.
      #
      # @return [undefined]
      def close
      end

      # Parses a query expression given by a String or a block and returns the
      # resulting AST
      #
      # Example
      #
      #   # with a string
      #   op = conn.parse "(restrict :suppliers, lambda{ city == 'London' })"
      #
      #   # or with a block
      #   op = conn.parse {
      #     (restrict :suppliers, lambda{ city == 'London' })
      #   }
      #
      # @param [String] expr a Lispy expression to compile
      # @return [Object] The AST resulting from the parsing
      def parse(expr = nil, path = nil, line = nil, &block)
        if (expr && block) || (expr.nil? and block.nil?)
          raise ArgumentError, "Either `expr` or `block` should be specified"
        end

        # parse through a scope unless a Symbol
        if block or expr.is_a?(String)
          expr = scope.evaluate(expr, path, line, &block)
        end

        # Special VarRef case
        if expr.is_a?(Symbol)
          expr = Operator::VarRef.new(self, expr)
        end
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
        case expr = parse(expr, path, line, &block)
        when Operator::VarRef then base_relvar(expr.name)
        else Relvar::Virtual.new(self, nil, expr)
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
        expr = optimizer.call(expr)
        cog  = compiler.call(expr)
        Tools.to_relation(cog)
      end

    end # module External
  end # module Context
end # module Alf
