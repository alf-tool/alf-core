module Alf
  class Heading
    
    #
    # Parses a Heading literal
    #
    def self.parse(str)
      if str.strip =~ /^Alf::Heading(\[.*\]|::EMPTY)$/
        Kernel.eval(str)
      else
        raise ArgumentError, "Invalid heading literal #{str}"
      end
    end
    
    #
    # Creates a Heading instance
    #
    # @param [Hash] a hash of attribute (name, type) pairs where name is
    #        a Symbol and type is a Class
    #
    def self.[](attributes)
      Heading.new(attributes) 
    end

    # @return [Hash] a (freezed) hash of (name, type) pairs  
    attr_reader :attributes
    
    #
    # Creates a Heading instance
    #
    # @param [Hash] a hash of attribute (name, type) pairs where name is
    #        a Symbol and type is a Class
    #
    def initialize(attributes)
      @attributes = attributes.dup.freeze
    end
    
    #
    # Returns heading's cardinality
    #
    def cardinality
      attributes.size
    end
    alias :size  :cardinality
    alias :count :cardinality
    
    #
    # Returns heading's hash code
    # 
    def hash
      @hash ||= attributes.hash
    end
    
    #
    # Checks equality with other heading
    #
    def ==(other)
      other.is_a?(Heading) && (other.attributes == attributes) 
    end
    alias :eql? :==
    
    #
    # Converts this heading to a Hash of (name,type) pairs
    # 
    def to_hash
      attributes.dup
    end
    
    # 
    # Returns a Heading literal
    #
    def inspect
      attributes.empty? ?
        "Alf::Heading::EMPTY" :
        "Alf::Heading[#{attributes.inspect[1...-1]}]"
    end
    
    EMPTY = Alf::Heading.new({})
  end # class Heading
end # module Alf