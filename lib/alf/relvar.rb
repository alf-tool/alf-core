module Alf
  #
  # Captures a database relation variable.
  #
  class Relvar
    include Iterator

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

  end # class Relvar
end # module Alf
require_relative 'relvar/base'
require_relative 'relvar/virtual'
require_relative 'relvar/memory'