module Alf
  #
  # Captures a database relation variable.
  #
  class Relvar
    include Iterator

  	# The database that served this relvar.
  	attr_reader :database

  	# Name of the relvar
  	attr_reader :name

  	# Creates a relvar instance.
  	#
  	# @param [Database] database the database to which this relvar belongs.
    # @param [Symbol] name the relvar name inside the database.
  	def initialize(database, name)
  		@database = database
      @name = name
  	end

    # Delegates to the dataset served by the database.
    def each(&bl)
      compile(database).each(&bl)
    end

    # Returns the relation value that this variable currently holds.
    #
    # @return [Relation] a relation value. 
    def value
      Tools.to_relation compile(database)
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