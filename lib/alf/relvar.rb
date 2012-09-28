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

    # Returns true if this relvar is empty, false otherwise
    def empty?
      each{ return false }
      true
    end

    # Raises a Alf::FactAssertionError unless the relvar is empty
    def empty!
      raise FactAssertionError unless empty?
      true
    end

    # Raises a Alf::FactAssertionError if the relvar is empty
    def not_empty!
      raise FactAssertionError if empty?
      true
    end

    # Returns the relation value that this variable currently holds.
    #
    # @return [Relation] a relation value.
    def value
      Relation.coerce _compile
    end
    alias :to_relation :value

    # Affects the current value of this relation variable.
    def affect(value)
      in_transaction do
        delete
        insert(value)
      end
    end

    # Inserts some tuples inside this relation variable.
    def insert(tuples)
      tuples = [ tuples ] if TupleLike===tuples
      in_transaction do
        Update::Inserter.new.call(expr, tuples)
      end
    end

    # Updates all tuples of this relation variable.
    def update(computation, predicate = Predicate.tautology)
      in_transaction do
        Update::Updater.new.call(expr, computation, predicate)
      end
    end

    # Delete all tuples of this relation variable.
    def delete(predicate = Predicate.tautology)
      in_transaction do
        Update::Deleter.new.call(expr, predicate)
      end
    end

    def to_lispy
      Support.to_lispy(expr)
    end

  private

    def in_transaction(&bl)
      context.in_transaction(&bl)
    end

    def _compile
      expr = self.expr
      expr = context.optimizer.call(expr)
      expr = context.compiler.call(expr)
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