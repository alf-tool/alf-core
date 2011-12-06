module Alf
  module Types
    #
    # Attribute list.
    #
    # An attribute list is an ordered collection of attribute names (see 
    # AttrName).
    #
    class AttrList

      # @return [Array<AttrName>] the list of attribute names
      attr_accessor :attributes

      # Creates an AttrList instance.
      #
      # @param [Array<AttrName>] the list of attribute names
      def initialize(attributes)
        @attributes = attributes
      end

      # Coerces `arg` to an AttrList.
      #
      # Recognizes coercions are:
      # - AttrList -> self
      # - Ordering -> the underlying list of attributes
      # - Array    -> through AttrName coercion of its elements
      #
      # @param [Object] arg the value to coerce to an AttrList
      # @return [AttrList] an attribute list if coercion succeeds
      # @raise [ArgumentError] if the coercion fails
      def self.coerce(arg)
        case arg
        when AttrList
          arg
        when Ordering
          AttrList.new(arg.attributes)
        when Array
          AttrList.new(arg.collect{|s| Tools.coerce(s, AttrName)})
        else
          raise ArgumentError, "Unable to coerce #{arg} to a projection key"
        end
      end

      # Builds an AttrList from commandline arguments.
      #
      # This method relies on `coerce` and therefore shares its spec.
      #
      # @param [Array] argv an array of commandline arguments
      # @param [Hash] opts convertion options (unused)
      # @return [AttrList] an attribute list if coercion succeeds
      # @raise [ArgumentError] if the coercion fails
      def self.from_argv(argv, opts = {})
        coerce(argv)
      end

      # Converts this attribute list to an ordering.
      #
      # @param [Symbol] :asc or :desc for ordering direction
      # @return [Ordering] an ordering instance
      def to_ordering(order = :asc)
        Ordering.new attributes.map{|arg| [arg, order]}
      end

      # Splits a tuple in two parts according `allbut`.
      #
      # Example:
      #   list = AttrList.new([:name])
      #   tuple = {:name => "Jones", :city => "London"}
      #
      #   list.split(tuple)
      #   # => [{:name => "Jones"}, {:city => "London"}]
      #
      #   list.split(tuple, true)
      #   # => [{:city => "London"}, {:name => "Jones"}]
      #
      # @param [Hash] tuple a tuple to split
      # @param [Boolean] allbut unknown attributes as first result?
      # @return [Array<Hash>] an array containing two tuples, according to known
      #         attributes and `allbut`
      def split(tuple, allbut = false)
        projection, rest = {}, tuple.dup
        attributes.each do |a|
          projection[a] = tuple[a]
          rest.delete(a)
        end
        allbut ? [rest, projection] : [projection, rest]
      end

      # Projects `tuple` on known (or unknown) attributes.
      # 
      # Example:
      #   list = AttrList.new([:name])
      #   tuple = {:name => "Jones", :city => "London"}
      #
      #   list.project(tuple)
      #   # => {:name => "Jones"}
      #
      #   list.project(tuple, true)
      #   # => {:city => "London"}
      #
      # @param [Hash] tuple a tuple to project
      # @param [Boolean] allbut projection?
      # @return Hash the projected tuple
      def project(tuple, allbut = false)
        split(tuple, allbut).first
      end

      # Checks equality with another attribute list.
      #
      # @param [Object] other another attribute list
      # @return [Boolean] true if `other` is an attribute list and contains
      #         the same attributes, in the same order
      def ==(other)
        other.is_a?(AttrList) && (other.attributes == attributes)
      end
      alias :eql? :==

      # Returns an hash code.
      def hash
        attributes.hash
      end

    end # class AttrList
  end # module Types
end # module Alf
