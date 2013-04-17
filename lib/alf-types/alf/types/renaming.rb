module Alf
  module Types
    #
    # Encapsulates a Renaming information
    #
    class Renaming
      extend Domain::Reuse.new(Hash)

      coercions do |c|
        c.delegate :to_renaming
        c.coercion(Hash){|arg,_|
          Renaming.new Hash[arg.map{|k,v| [ AttrName.coerce(k), AttrName.coerce(v) ] }]
        }
        c.coercion(Array){|arg,_|
          coerce(Hash[*arg])
        }
      end

      reuse  :[], :to_hash
      recoat :invert

      # Returns a completed renaming with at least all attributes in `attr_list`
      def complete(attr_list)
        Renaming.new attr_list.to_a.each_with_object(reused_instance.dup){|k,h| h[k] ||= k}
      end

      # Renames a tuple according to this renaming pairs.
      #
      # The tuple should have all attributes defined in this renaming. Strange
      # results may appear otherwise.
      #
      # @param [Hash] tuple a tuple to rename
      # @return [Hash] the renamed tuple
      def rename_tuple(tuple)
        Hash[tuple.map{|k,v| [self[k] || k, v]}]
      end

      # Renames an attribute list.
      #
      # @param [AttrList] an attribute list
      # @return [AttrList] the input list where attributes have been renamed
      def rename_attr_list(attr_list)
        AttrList.coerce(attr_list).map{|k| self[k] || k}
      end

      # Returns self
      def to_renaming
        self
      end

      # Returns a lispy expression.
      #
      # @return [String] a lispy expression for this renaming
      def to_lispy
        Support.to_ruby_literal(to_hash)
      end

      # Returns an attribute list with renaming keys
      def to_attr_list
        AttrList.new reused_instance.keys
      end

      # Returns a ruby literal for this renaming.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::Renaming[#{Support.to_ruby_literal(reused_instance)}]"
      end
      alias :inspect :to_ruby_literal
      alias :to_s :to_ruby_literal

    end # class Renaming
  end # module Types
end # module Alf
