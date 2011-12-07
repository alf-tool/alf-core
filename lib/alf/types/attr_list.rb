module Alf
  module Types
    #
    # An attribute list is an ordered collection of attribute names (see 
    # AttrName).
    #
    # Example:
    #
    #     list = AttrList[:name, :city]
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

      class << self

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
        def coerce(arg)
          return arg.to_attr_list if arg.respond_to?(:to_attr_list)
          case arg
          when Array
            AttrList.new(arg.collect{|s| Tools.coerce(s, AttrName)})
          else
            raise ArgumentError, "Unable to coerce #{arg} to a projection key"
          end
        end

        # Coerces a list of names to an AttrList.
        #
        # @param [Array] args a list of names (Symbol or String)
        # @return [AttrList] an attribute list
        def [](*args)
          coerce(args)
        end

        # Builds an AttrList from commandline arguments.
        #
        # This method relies on `coerce` and therefore shares its spec.
        #
        # @param [Array] argv an array of commandline arguments
        # @param [Hash] opts convertion options (unused)
        # @return [AttrList] an attribute list if coercion succeeds
        # @raise [ArgumentError] if the coercion fails
        def from_argv(argv, opts = {})
          coerce(argv)
        end

      end # class << self

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
      #   list.split_tuple(tuple)
      #   # => [{:name => "Jones"}, {:city => "London"}]
      #
      #   list.split_tuple(tuple, true)
      #   # => [{:city => "London"}, {:name => "Jones"}]
      #
      # @param [Hash] tuple a tuple to split
      # @param [Boolean] allbut unknown attributes as first result?
      # @return [Array<Hash>] an array containing two tuples, according to known
      #         attributes and `allbut`
      def split_tuple(tuple, allbut = false)
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
      #   list.project_tuple(tuple)
      #   # => {:name => "Jones"}
      #
      #   list.project_tuple(tuple, true)
      #   # => {:city => "London"}
      #
      # @param [Hash] tuple a tuple to project
      # @param [Boolean] allbut projection?
      # @return Hash the projected tuple
      def project_tuple(tuple, allbut = false)
        split_tuple(tuple, allbut).first
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
      #
      # @return [Integer] an hash code for this attribute list
      def hash
        attributes.hash
      end

      # Converts to an attribute list.
      #
      # @return [AttrList] return self
      def to_attr_list
        self
      end

      # Returns a ruby literal for this attribute list.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::AttrList#{Tools.to_ruby_literal(attributes)}"
      end
      alias :inspect :to_ruby_literal

    end # class AttrList
  end # module Types
end # module Alf
