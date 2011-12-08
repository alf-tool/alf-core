module Alf
  module Types
    #
    # Defines a Heading, that is, a set of attribute (name,domain) pairs.
    #
    class Heading
      include Enumerable

      # @return [Hash] a (freezed) hash of (name, type) pairs
      attr_reader :attributes

      # Creates a Heading instance
      #
      # @param [Hash] a hash of attribute (name, type) pairs where name is
      #        an AttrName and type is a Class
      def initialize(attributes)
        @attributes = attributes.dup.freeze
      end

      class << self

        # Coerces `arg` to a Heading.
        #
        # Implemented coercions are:
        # - Array: [AttrName, Module, ..., AttrName, Module]
        # - Hash:  {AttrName => Module, ..., AttrName => Module}
        #
        # @param [Object] arg value to coerce to a Heading
        # @return [Heading] a heading instance when coercion succeeds
        # @raise [ArgumentError] is coercion fails
        def coerce(arg)
          case arg
          when Heading
            arg
          when Array
            Heading.new Hash[arg.each_slice(2).map{|k,v|
              [ Tools.coerce(k, Symbol), 
                Tools.coerce(v, Module) ]
            }]
          when Hash
            Heading.new Hash[arg.map{|k,v|
              [ Tools.coerce(k, Symbol), 
                Tools.coerce(v, Module) ]
            }]
          else
            raise ArgumentError, "Unable to coerce #{arg.inspect} to a Heading"
          end
        end
        alias :[] :coerce

        # Coerces commandline arguments to a Heading.
        #
        # This method simply reuses `coerce(Array)` and therefore shares its 
        # spec.
        #
        # @param [Array] argv commandline arguments
        # @param [Hash] opts options (unused)
        # @return [Heading] a heading instance when coercion succeeds
        # @raise [ArgumentError] is coercion fails
        def from_argv(argv, opts = {})
          coerce(argv)
        end

      end # class << self

      # Yields each (name,domain) pair in turn.
      def each(&block)
        attributes.each(&block)
      end

      # Returns heading's cardinality, i.e. the number of (name,type) pairs.
      #
      # @return [Integer] the number of pairs
      def cardinality
        attributes.size
      end
      alias :size  :cardinality
      alias :count :cardinality

      # Computes the union of this heading with `other`.
      #
      # When self and other have no common attribute names, compute the 
      # classical set union on pairs. Otherwise, the type of a common attribute
      # is returned as the common super type (see `Types.common_super_type`).
      #
      # @param [Heading] other another heading
      # @return [Heading] the union of this heading with `other`
      def union(other)
        Heading.new attributes.merge(other.attributes){|k,t1,t2|
          Types.common_super_type(t1, t2)
        }
      end
      alias :+ :union
      alias :join :union

      # Returns heading's hash code
      #
      # @return [Integer] the heading's hash code
      def hash
        attributes.hash
      end

      # Checks equality with other heading
      #
      # Classical set equality applies to headings.
      #
      # @param [Heading] other another heading
      # @return [Boolean] true if other is the same heading than self, false
      #         otherwise
      def ==(other)
        other.is_a?(Heading) && (attributes == other.attributes) 
      end
      alias :eql? :==
      
      # Converts this heading to a Hash of (name,type) pairs
      #
      # @return [Hash] this heading as a Hash of (name, type) pairs
      def to_h
        attributes.dup
      end

      # Returns a Heading literal
      #
      # @return [String] a Heading literal
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
