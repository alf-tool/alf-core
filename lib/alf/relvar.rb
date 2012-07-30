module Alf
  #
  # Captures a database relation variable.
  #
  class Relvar
    include Iterator
    include Lang::ObjectOriented

    # The context under which this relvar was served.
    attr_reader :context

    # Name of the relvar
    attr_reader :name

    # Creates a relvar instance.
    #
    # @param [Object] context the context that served this relvar.
    # @param [Symbol] name the relvar name inside the database.
    def initialize(context, name)
      @context = context
      @name = name
    end

    def scope
      context
    end

    # Returns the relation variable heading
    def heading
      context.heading(name)
    end

    # Returns the relation variable keys
    def keys
      context.keys(name)
    end

    # Delegates to the context.
    def each(&bl)
      compile(context).each(&bl)
    end

    # Returns the relation value that this variable currently holds.
    #
    # @return [Relation] a relation value.
    def value
      Tools.to_relation compile(context)
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

    def _operator_output(op)
      Relvar::Virtual.new(context, nil, op)
    end

    def _self_operand
      self
    end

  end # class Relvar
end # module Alf
require_relative 'relvar/base'
require_relative 'relvar/virtual'
require_relative 'relvar/memory'