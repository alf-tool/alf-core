module Alf
  module Types
    #
    # Defines a Heading, that is, a set of attribute (name,domain) pairs.
    #
    class Heading
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

      class << self
        alias_method :[], :coerce
      end # class << self

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
        Heading.new renaming.rename_tuple(attributes)
      end

      # Projects this heading on specified names.
      #
      # @param [AttrList] names an enumerable of attribute names.
      # @param [Boolean] allbut apply a allbut projection?
      def project(names, allbut = false)
        Heading[AttrList.coerce(names).project_tuple(attributes, allbut)]
      end

      # Converts this heading to an attribute list.
      #
      # @return [AttrList] heading's attributes as an attribute list
      def to_attr_list
        AttrList.new attributes.keys
      end

      # Returns a Heading literal
      #
      # @return [String] a Heading literal
      def to_ruby_literal
        attributes.empty? ?
          "Alf::Heading::EMPTY" :
          "Alf::Heading[#{Support.to_ruby_literal(attributes)[1...-1]}]"
      end
      alias_method :inspect, :to_ruby_literal

      EMPTY = Heading.new({})
    end # class Heading
  end # module Types
end # module Alf
