module Alf
  module Types
    #
    # Encapsulates a Renaming information
    #
    class Renaming
      include Myrrha::Domain::Impl.new([:renaming])

      coercions do |c|
        c.delegate :to_renaming
        c.coercion(Hash){|arg,_|
          Renaming.new Hash[arg.map{|k,v| [ AttrName.coerce(k), AttrName.coerce(v) ] }]
        }
        c.coercion(Array){|arg,_|
          coerce(Hash[*arg])
        }
      end

      class << self

        alias :[] :coerce

        # Converts commandline arguments to a renaming.
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

      # Returns the renaming of `name`
      def [](name)
        renaming[name]
      end

      # Returns the inverse renaming.
      #
      # @return [Renaming] the inversed renaming
      def inverse
        inversed = {}
        renaming.each_pair{|k,v| inversed[v] = k}
        Renaming.new inversed
      end

      # Returns a completed renaming with at least all attributes in `attr_list`
      def complete(attr_list)
        completed = renaming.dup
        attr_list.to_a.each{|k| completed[k] ||= k}
        Renaming.new completed
      end

      # Renames a tuple according to this renaming pairs.
      #
      # The tuple should have all attributes defined in this renaming. Strange
      # results may appear otherwise.
      #
      # @param [Hash] tuple a tuple to rename
      # @return [Hash] the renamed tuple
      def rename_tuple(tuple)
        Hash[tuple.map{|k,v| [@renaming[k] || k, v]}]
      end

      # Renames an attribute list.
      #
      # @param [AttrList] an attribute list
      # @return [AttrList] the input list where attributes have been renamed
      def rename_attr_list(attr_list)
        attr_list = AttrList.coerce(attr_list)
        AttrList.new attr_list.attributes.map{|k| renaming[k] || k}
      end

      # Returns this renaming as a Hash
      def to_hash
        renaming.dup
      end

      # Returns self
      def to_renaming
        self
      end

      # Returns an attribute list with renaming keys
      def to_attr_list
        AttrList.new renaming.keys
      end

      # Returns a ruby literal for this renaming.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::Renaming[#{Support.to_ruby_literal(renaming)}]"
      end
      alias :inspect :to_ruby_literal

    end # class Renaming
  end # module Types
end # module Alf
