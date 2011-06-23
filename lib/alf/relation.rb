require 'set'
module Alf
  #
  # Defines an in-memory relation 
  #
  class Relation
    
    protected
    
    # @return [Set] the set of tuples
    attr_reader :tuples
    
    public
    
    #
    # Creates a Relation instance.
    #
    # @param [Set] tuples a set of tuples
    #
    def initialize(tuples)
      @tuples = tuples
    end
    
    #
    # Coerces `val` to a relation
    #
    def self.coerce(val)
      case val
      when Relation
        val
      when Set
        Relation.new(val)
      when Array
        Relation.new val.to_set
      when Iterator
        Relation.new val.to_set
      end
    end
    
    # (see Object#hash)
    def hash
      @tuples.hash
    end
    
    # (see Object#==)
    def ==(other)
      return nil unless other.is_a?(Relation)
      other.tuples == self.tuples
    end
    alias :eql? :==
    
  end # class Relation
end # module Alf