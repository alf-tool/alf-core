module Alf
  module Relvar
    include Algebra::Operand
    include Lang::ObjectOriented

    def each(&bl)
      to_cog.each(&bl)
    end

    def empty?
      to_cog.each{|_| return false }
      true
    end

    def empty!
      raise FactAssertionError unless empty?
      true
    end

    def not_empty!
      raise FactAssertionError if empty?
      true
    end

    def value
      to_relation
    end

    def affect(value)
      delete
      insert(value)
    end

    def to_relvar
      self
    end

    def to_relation
      to_cog.to_relation
    end

  private

    def _operator_output(expr)
      Relvar::Virtual.new(expr, connection)
    end

  end # module Relvar
end # module Alf
require_relative 'relvar/base'
require_relative 'relvar/virtual'
require_relative 'relvar/read_only'
