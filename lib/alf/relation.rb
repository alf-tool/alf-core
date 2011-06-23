module Alf
  #
  # Defines an in-memory relation 
  #
  class Relation
    include Iterator
    
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
      raise ArgumentError unless tuples.is_a?(Set)
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
      else
        raise ArgumentError, "Unable to coerce #{val} to a Relation"
      end
    end
    
    # (see Relation.coerce)
    def self.[](*tuples)
      coerce(tuples)
    end
    
    # (see Iterator#each)
    def each(&block)
      tuples.each(&block)
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
    
    def to_s
      Alf::Renderer.text(self).execute("")
    end

  end # class Relation
end # module Alf