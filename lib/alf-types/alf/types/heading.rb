module Alf
  module Types
    #
    # Defines a Heading, that is, a set of attribute (name,domain) pairs.
    #
    class Heading
      include Comparable
      extend Domain::Reuse.new(Hash)

      coercions do |c|
        c.delegate :to_heading
        c.coercion(Array){|arg,_|
          Heading.new Hash[arg.each_slice(2).map{|k,v|
            [ AttrName.coerce(k), Support.coerce(v, Module) ]
          }]
        }
        c.coercion(Hash){|arg,_|
          Heading.new Hash[arg.map{|k,v|
            [ AttrName.coerce(k), Support.coerce(v, Module) ]
          }]
        }
      end

      def self.infer(arg)
        return arg.to_heading if arg.respond_to?(:to_heading)
        return arg.heading    if arg.respond_to?(:heading)
        arg = [ arg ] if TupleLike===arg
        Heading.new(Engine::InferHeading.new(arg).first)
      end

      reuse :each, :[], :size, :to_hash, :map

      alias_method :attributes, :reused_instance
      alias_method :cardinality, :size
      alias_method :count, :size
      alias_method :to_h, :to_hash

      # Computes the intersection of this heading with another one.
      #
      # @param [Heading] other another heading
      # @return [Heading] the intersection of this heading with `other`
      def intersection(other)
        attrs = (to_attr_list & other.to_attr_list).to_a
        Heading.new Hash[attrs.map{|name|
          [name, Types.common_super_type(self[name], other[name])]
        }]
      end
      alias_method :&, :intersection

      # Computes the union of this heading with `other`.
      #
      # When self and other have no common attribute names, compute the classical set
      # union on pairs. Otherwise, the type of a common attribute is returned as the
      # common super type (see `Types.common_super_type`).
      #
      # @param [Heading] other another heading
      # @return [Heading] the union of this heading with `other`
      def union(other)
        Heading.new attributes.merge(other.attributes){|k,t1,t2|
          Types.common_super_type(t1, t2)
        }
      end
      alias_method :+, :union
      alias_method :join, :union

      # Splits this heading according to an attribute list
      #
      # @return [Array[Heading]] an array of two headings.
      def split(names, allbut=false)
        l, r = AttrList.coerce(names).split_tuple(attributes, allbut)
        [Heading.new(l), Heading.new(r)]
      end

      # Projects this heading on specified names.
      #
      # @param [AttrList] names an enumerable of attribute names.
      # @param [Boolean] allbut apply a allbut projection?
      def project(names, allbut = false)
        Heading[AttrList.coerce(names).project_tuple(attributes, allbut)]
      end

      # Projects this heading on all but specified names.
      #
      # @param [AttrList] names an enumerable of attribute names.
      def allbut(names)
        project(names, true)
      end

      # Computes the merge of this heading with `other`.
      #
      # When self and other have no common attribute names, compute the
      # classical set union on pairs. Otherwise, the type of a common attribute
      # is returned as the one of `other`
      #
      # @param [Heading] other another heading
      # @return [Heading] the merge of this heading with `other`
      def merge(other)
        Heading.new attributes.merge(Heading[other].attributes)
      end

      # Renames according to a Renaming instance.
      #
      # @param [Renaming] a renaming instance
      # @return [Heading] a renamed heading
      def rename(renaming)
        Heading.new Renaming.coerce(renaming).rename_tuple(attributes)
      end

      # Compares this heading with another one
      #
      # @return [Fixnum] -1 if a self is a sub heading, 0 if equal, 1 if a super heading,
      #                  nil if not comparable.
      def <=>(other)
        return nil unless other.is_a?(Heading) && to_attr_list==other.to_attr_list
        comparisons = attributes.keys.map{|k| self[k] <=> other[k] }.reject{|x| x == 0}.uniq
        case comparisons.size
        when 0 then 0
        when 1 then comparisons.first
        else nil
        end
      end

      # Check conformance of a given tuple.
      #
      # @return [Boolean] true if the tuple conforms to this heading, false otherwise.
      def ===(tuple)
        return false unless tuple.respond_to?(:to_hash)
        types, values = attributes, tuple.to_hash
        (types.size == values.size) && types.keys.all?{|k| types[k]===values[k]}
      end

      # Return self
      #
      # @return [Heading] this heading
      def to_heading
        self
      end

      # Converts this heading to an attribute list.
      #
      # @return [AttrList] heading's attributes as an attribute list
      def to_attr_list
        AttrList.new attributes.keys
      end

      # Returns a lispy expression.
      #
      # @return [String] a lispy expression for this heading
      def to_lispy
        "{" << to_h.map{|k,v| "#{k}: #{Support.to_lispy(v)}" }.join(', ') << "}"
      end

      # Returns a Heading literal
      #
      # @return [String] a Heading literal
      def to_ruby_literal
        attributes.empty? ?
          "Alf::Heading::EMPTY" :
          "Alf::Heading[#{Support.to_ruby_literal(attributes)[1...-1]}]"
      end
      alias_method :to_s,    :to_ruby_literal
      alias_method :inspect, :to_ruby_literal

      EMPTY = Heading.new({})
    end # class Heading
  end # module Types
end # module Alf
