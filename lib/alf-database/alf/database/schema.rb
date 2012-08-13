module Alf
  class Database
    class Schema

      def initialize(database, definition)
        @database   = database
        @definition = definition
      end
      attr_reader :database, :definition

      def parse(expr = nil, path = nil, line = nil, &block)
        if (expr && block) || (expr.nil? and block.nil?)
          raise ArgumentError, "Either `expr` or `block` should be specified"
        end

        # parse through a scope unless a Symbol
        if block or expr.is_a?(String)
          expr = scope.evaluate(expr, path, line, &block)
        end

        # Special VarRef case
        expr = scope.__send__(expr) if expr.is_a?(Symbol)

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

      def tuple_extract(*args, &bl)
        query(*args, &bl).tuple_extract
      end

      def relvar(expr = nil, path = nil, line = nil, &block)
        Relvar.new database, parse(expr, path, line, &block)
      end

      # @api private
      def scope
        definition.scope(database)
      end

    private

      def with_connection
        yield(database.connection)
      end

    end # class Schema
  end # class Database
end # module Alf