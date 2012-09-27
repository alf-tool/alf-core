module Alf
  module Types
    #
    # An attribute list is an ordered collection of attribute names (see AttrName).
    #
    # Example:
    #
    #     list = AttrList[:name, :city]
    #
    class AttrList
      extend Domain::Reuse.new(Array)
      include Support::OrderedSet

      coercions do |c|
        c.delegate :to_attr_list
        c.coercion(Array){|v,_| AttrList.new(v.map{|a| AttrName.coerce(a) })}
      end

      class << self

        # Coerces a list of names to an AttrList.
        #
        # @param [Array] args a list of names (Symbol or String)
        # @return [AttrList] an attribute list
        def [](*args)
          coerce(args)
        end

      end # class << self

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
        each do |a|
          projection[a] = tuple[a] if tuple.has_key?(a)
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

      # Projects this attribute list on a subset of attributes `attrs`.
      #
      # @param [AttrList] attrs a subset of these attributes
      # @param [Boolean] allbut projection?
      # @return [AttrList] the projection as an attribute list
      def project(attrs, allbut = false)
        allbut ? self - attrs : self & attrs
      end

      # Compares this attribute list with `other` on a set basis.
      #
      # @param [AttrList] other another attribute list
      # @return [Integer] 0 if same set of attribute names, -1 if self is a subset of
      # other, 1 if a superset, nil otherwise.
      def set_compare(other)
        return nil unless other.is_a?(AttrList)
        s1, s2 = to_set, other.to_set
        if s1==s2 
          0
        elsif s1.subset?(s2)
          -1
        elsif s1.superset?(s2)
          1
        end
      end

      # Returns true if this attribute list captures the same set of attribute names than
      # `other`.
      def sameset?(other)
        c = set_compare(other)
        c and (c==0)
      end

      # Returns true if self is a (proper) superset of `other`
      def superset?(other, proper = false)
        c = set_compare(other)
        c and (c >= (proper ? 1 : 0))
      end

      # Returns true if self is a (proper) subset of `other`
      def subset?(other, proper = false)
        c = set_compare(other)
        c and (c <= (proper ? -1 : 0))
      end

      # Returns true if self intersects another attribute list
      def intersect?(other)
        !((self & other).empty?) || (empty? && other.empty?)
      end

      # Converts to an attribute list.
      #
      # @return [AttrList] return self
      def to_attr_list
        self
      end

      # Converts this attribute list to an ordering.
      #
      # @param [Symbol] :asc or :desc for ordering direction
      # @return [Ordering] an ordering instance
      def to_ordering(order = :asc)
        Ordering.new elements.map{|arg| [arg, order]}
      end

      # Returns a ruby literal for this attribute list.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::AttrList#{Support.to_ruby_literal(to_a)}"
      end
      alias :inspect :to_ruby_literal

      EMPTY = AttrList.new([])

    end # class AttrList
  end # module Types
end # module Alf
