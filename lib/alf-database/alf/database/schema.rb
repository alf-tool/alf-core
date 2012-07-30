module Alf
  class Database
    class Schema

      attr_reader :database, :definition

      def initialize(database, definition)
        @database = database
        @definition = definition
      end

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

      def query(expr = nil, path = nil, line = nil, &block)
        with_connection do |conn|
          expr = parse(expr, path, line, &block)
          expr = conn.optimizer.call(expr)
          cog  = conn.compiler.call(expr)
          Tools.to_relation(cog)
        end
      end

      def relvar(expr = nil, path = nil, line = nil, &block)
        Relvar.new @database, parse(expr, path, line, &block)
      end

      # @api private
      def scope
        @database.scope [ definition ]
      end

    private

      def with_connection
        yield(database.connection)
      end

    end # class Schema
  end # class Database
end # module Alf