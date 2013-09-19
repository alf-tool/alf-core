module Alf
  module Types
    #
    # Defines an ordering on tuple attributes
    #
    class Ordering
      extend Domain::Reuse.new(Array)

      def self.new(array)
        super(array.map{|(x,y)| [Selector.coerce(x), y.to_sym] })
      end

      ArrayOfArray = ->(x){
        x.is_a?(Array) && x.all?{|y| y.is_a?(Array)}
      }
      ArrayWithDirections = ->(x){
        x.each_with_index.all?{|elm,i| (i%2==0) || elm.to_s =~ /^asc|desc$/ }
      }

      coercions do |c|
        c.delegate :to_ordering
        c.coercion(ArrayOfArray){|arg,_|
          Ordering.new(arg)
        }
        c.coercion(ArrayWithDirections){|arg,_|
          Ordering.new(arg.each_slice(2).to_a)
        }
        c.coercion(Array){|arg,_|
          Ordering.new(arg.map{|x| [x, :asc] })
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

      # Returns the directions associated with an attribute name, nil
      # if no such attribute.
      #
      # @param [Symbol] an attribute name.
      # @return [Symbol] the associated direction or nil
      def [](attribute)
        attribute = Selector.coerce(attribute)
        pair = reused_instance.find{|p| p.first == attribute }
        pair && pair.last
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
      def compare(t1, t2)
        extract = proc{|t,x| Array(x).inject(t){|m,a| m[a]} }
        reused_instance.each do |atr, dir|
          x, y = extract[t1,atr], extract[t2,atr]
          comp = x.respond_to?(:<=>) ? (x <=> y) : (x.to_s <=> y.to_s)
          comp *= -1 if dir == :desc
          return comp unless comp == 0
        end
        return 0
      end

      # Computes the union of this ordering with another one.
      #
      # The union is simply defined by extension of self with other's
      # attributes and directions. Duplicates are automatically removed.
      #
      # When a conflict arises (same attribute but not same direction),
      # the block is yield with the attribute name, then `self`'s and `other`'s
      # directions as arguments. The block is expected to return the direction
      # to use to the attribute. A default block is provided that always favors
      # the direction found in `other`.
      #
      # @param [Ordering] other another Ordering (coercions will apply)
      # @return [Ordering] the union ordering
      def merge(other, &bl)
        bl ||= lambda{|attr,d1,d2| d2 }
        other = Ordering.coerce(other)
        attributes = self.selectors | other.selectors
        directions = attributes.to_a.map{|a|
          left, right = self[a], other[a]
          direction = if left.nil? or right.nil?
                        left || right
                      elsif left == right
                        left
                      else
                        bl.call(a, left, right)
                      end
          [a, direction]
        }
        Ordering.new(directions)
      end
      alias :+ :merge

      # Reverse this ordering.
      #
      # @return [Ordering] another ordering where the direction of every
      #         attribute has been flipped (asc <-> desc)
      def reverse
        Ordering.new(reused_instance.map{|attr,dir|
          [ attr, dir == :asc ? :desc : :asc ]
        })
      end

      # Dives into a relation/tuple valued attribute `attr`.
      #
      # @return [Ordering] the sub-ordering to use for `attr`
      def dive(attr)
        attrs = reused_instance
              .map   {|(s,d)| [s.dive(attr), d] }
              .reject{|(s,d)| s.nil? }
        Ordering.new(attrs)
      end

      # Returns the list of selectors
      #
      # @return [Array[Selector]] the list of selectors
      def selectors
        reused_instance.map(&:first)
      end

      # Converts to an attribute list.
      #
      # @return [AttrList] a list of attribute names that participate to the
      #         ordering
      def to_attr_list
        AttrList.new(selectors.map{|x| Array(x).first })
      end

      # Returns a lispy expression.
      #
      # @return [String] a lispy expression for this ordering
      def to_lispy
        Support.to_ruby_literal(to_a.map{|(x,d)| [x.outcoerce, d]})
      end

      # Returns a ruby literal for this ordering.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::Ordering[#{Support.to_ruby_literal(reused_instance)}]"
      end

      alias :to_s :to_ruby_literal
      alias :inspect :to_ruby_literal

      EMPTY = Ordering.new([])
    end # class Ordering
  end # module Types
end # module Alf
