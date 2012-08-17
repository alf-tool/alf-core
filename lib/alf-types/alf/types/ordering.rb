module Alf
  module Types
    #
    # Defines an ordering on tuple attributes
    #
    class Ordering

      # @return [Array] underlying ordering as an array `[[attr1, dir1], ...]`
      attr_reader :ordering
      alias :to_a :ordering

      # @return [Proc] a Proc object that sorts tuples according to this
      #         ordering.
      attr_reader :sorter

      # Creates an ordering instance
      #
      # @param [Array] ordering the underlying ordering info
      def initialize(ordering = [])
        @ordering = ordering
        @sorter = lambda{|t1,t2| compare(t1, t2)}
      end

      class << self

        # Coerces `arg` to an ordering.
        #
        # Implemented coercions are:
        # * Ordering (self)
        # * Array of AttrName (all attributes in ascending order)
        # * Array of [AttrName, :asc|:desc] pairs (obvious semantics)
        # * AttrList (all its attributes in ascending order)
        #
        # @param [Object] arg the value to coerce as an Ordering
        # @return [Ordering] when coercion succeeds
        # @raises [ArgumentError] when coercion fails
        def coerce(arg)
          case arg
          when Ordering
            arg
          when AttrList
            arg.to_ordering(:asc)
          when Array
            if arg.all?{|a| a.is_a?(Array)}
              Ordering.new(arg)
            else
              symbolized = arg.collect{|s| Support.coerce(s, Symbol)}
              sliced = symbolized.each_slice(2)
              if sliced.all?{|a,o| [:asc,:desc].include?(o)}
                Ordering.new sliced.to_a
              else
                Ordering.new symbolized.map{|a| [a, :asc]}
              end
            end
          else
            raise ArgumentError, "Unable to coerce #{arg} to an ordering key"
          end
        end
        alias :[] :coerce

        # Converts commandline arguments to an ordering.
        #
        # This method reuses the `coerce(Array)` coercion heuristics and
        # therefore shares its spec.
        #
        # @param [Array] argv commandline arguments
        # @param [Hash] opts options (not used)
        # @return [Ordering] when coercion succeeds
        # @raises [ArgumentError] when coercion fails
        def from_argv(argv, opts = {})
          coerce(argv)
        end

      end # class << self

      # Returns the ordering attributes
      #
      # @return [Array<AttrName>] the list of attribute names
      def attributes
        @ordering.map{|arg| arg.first}
      end

      # Compares two tuples according to this ordering.
      #
      # Both t1 and t2 should have all attributes used by this ordering.
      # Strange results may appear if it's not the case.
      #
      # @param [Tuple] t1 a tuple
      # @param [Tuple] t2 another tuple
      # @return [-1, 0 or 1] according to the classical ruby semantics of
      #         `(t1 <=> t2)`
      def compare(t1,t2)
        ordering.each do |atr, dir|
          x, y = t1[atr], t2[atr]
          comp = x.respond_to?(:<=>) ? (x <=> y) : (x.to_s <=> y.to_s)
          comp *= -1 if dir == :desc
          return comp unless comp == 0
        end
        return 0
      end

      # Computes the union of this ordering with another one.
      #
      # The union is simply defined by extension of self with other's attributes
      # and directions.
      #
      # @param [Ordering] other another Ordering (coercions will apply)
      # @return [Ordering] the union ordering
      def +(other)
        Ordering.new(ordering + Ordering.coerce(other).ordering)
      end

      # Returns the ordering hash code.
      #
      # @return [Integer] a hash code for this ordering.
      def hash
        ordering.hash
      end

      # Checks equality with another ordering.
      #
      # @param [Ordering] other another Ordering instance
      # @return [Boolean] true if both orderings are the same, false otherwise
      def ==(other)
        other.is_a?(Ordering) && (other.ordering == ordering)
      end
      alias :eql? :==

      # Converts to an attribute list.
      #
      # @return [AttrList] a list of attribute names that participate to the
      #         ordering
      def to_attr_list
        AttrList.new(attributes)
      end

      # Returns a ruby literal for this ordering.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::Ordering[#{Support.to_ruby_literal(ordering)}]"
      end
      alias :inspect :to_ruby_literal

    end # class Ordering
  end # module Types
end # module Alf
