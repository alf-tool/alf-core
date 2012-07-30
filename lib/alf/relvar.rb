module Alf
  #
  # Captures a database relation variable.
  #
  class Relvar
    include Iterator
    include Lang::ObjectOriented

    # The context under which this relvar was served.
    attr_reader :context

    # Underlying expression
    attr_reader :expr

    # Creates a relvar instance.
    #
    # @param [Object] context the context that served this relvar.
    # @param [Object] expr the underlying expression
    def initialize(context, expr)
      @context = context
      @expr = expr
    end

    # Returns the scope
    def scope
      context
    end

    # Returns the relation variable heading
    def heading
      expr.heading
    end

    # Returns the relation variable keys
    def keys
      expr.keys
    end

    # Delegates to the context.
    def each(&bl)
      _compile.each(&bl)
    end

    # Returns the relation value that this variable currently holds.
    #
    # @return [Relation] a relation value.
    def value
      Tools.to_relation _compile
    end
    alias :to_relation :value

    # Affects the current value of this relation variable.
    def affect(value)
      raise NotImplementedError
    end

    # Inserts some tuples inside this relation variable.
    def insert(tuples)
      raise NotImplementedError
    end

    # Updates all tuples of this relation variable.
    def update(values)
      raise NotImplementedError
    end

    # Delete all tuples of this relation variable.
    def delete
      raise NotImplementedError
    end

  private

    def _compile
      context.connection.compiler.call(expr)
    end

    def _operator_output(op)
      Relvar.new(context, op)
    end

    def _self_operand
      expr
    end

  end # class Relvar
end # module Alf
require_relative 'relvar/memory'