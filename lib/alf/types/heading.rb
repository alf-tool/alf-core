module Alf
  module Types
    #
    # Defines a Heading, that is, a set of attribute (name,domain) pairs.
    #
    class Heading
      
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
      # Coerces `attributes` to a Heading instance
      #
      def self.coerce(attributes)
        case attributes
        when Array
          h = Tools.tuple_collect(attributes.each_slice(2)) do |k,v|
            [ Tools.coerce(k, Symbol), Tools.coerce(v, Module) ]
          end
          Heading.new(h)
        when Hash
          Heading.new(attributes)
        else
          raise ArgumentError, "Unable to coerce #{attributes.inspect} to a Heading"
        end
      end
      
      def self.from_argv(argv, opts = {})
        coerce(argv)
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
      def to_ruby_literal
        attributes.empty? ?
          "Alf::Heading::EMPTY" :
          "Alf::Heading[#{Tools.to_ruby_literal(attributes)[1...-1]}]"
      end
      alias :inspect :to_ruby_literal
      
      EMPTY = Heading.new({})
    end # class Heading    
  end # module Types
end # module Alf