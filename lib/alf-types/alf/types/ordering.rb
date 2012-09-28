module Alf
  module Types
    #
    # Defines an ordering on tuple attributes
    #
    class Ordering
      extend Domain::Reuse.new(Array)

      coercions do |c|
        c.delegate :to_ordering
        c.coercion(Array){|arg,_|
          if arg.all?{|a| a.is_a?(Array)}
            Ordering.new(arg)
          else
            symbolized = arg.map{|s| AttrName.coerce(s) }
            sliced = symbolized.each_slice(2)
            if sliced.all?{|a,o| [:asc,:desc].include?(o)}
              Ordering.new sliced.to_a
            else
              Ordering.new symbolized.map{|a| [a, :asc]}
            end
          end
        }
      end

      # @return [Proc] a Proc object that sorts tuples according to this
      #         ordering.
      attr_reader :sorter

      # Creates an ordering instance
      #
      # @param [Array] ordering the underlying ordering info
      def initialize(ordering = [])
        super
        @sorter = lambda{|t1,t2| compare(t1, t2)}
      end

      reuse :to_a

      # Compares two tuples according to this ordering.
      #
      # Both t1 and t2 should have all attributes used by this ordering.
      # Strange results may appear if it's not the case.
      #
      # @param [Tuple] t1 a tuple
      # @param [Tuple] t2 another tuple
      # @return [-1, 0 or 1] according to the classical ruby semantics of
      #         `(t1 <=> t2)`
      def compare(t1, t2)
        reused_instance.each do |atr, dir|
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
        Ordering.new(reused_instance + Ordering.coerce(other).reused_instance)
      end

      # Converts to an attribute list.
      #
      # @return [AttrList] a list of attribute names that participate to the
      #         ordering
      def to_attr_list
        AttrList.new(reused_instance.map(&:first))
      end

      # Returns a ruby literal for this ordering.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::Ordering[#{Support.to_ruby_literal(reused_instance)}]"
      end
      alias :inspect :to_ruby_literal

    end # class Ordering
  end # module Types
end # module Alf
