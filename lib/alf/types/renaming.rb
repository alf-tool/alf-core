module Alf
  module Types
    #
    # Encapsulates a Renaming information
    #
    class Renaming

      # @return [Hash] a renaming mapping as AttrName -> AttrName
      attr_reader :renaming

      # Creates a renaming instance
      #
      # @param [Hash] a renaming mapping as AttrName -> AttrName
      def initialize(renaming)
        @renaming = renaming
      end

      class << self

        # Coerces `arg` to a renaming
        #
        # Implemented coercions are:
        # - Renaming: self
        # - {old1 => new1, ...} with AttrName coercions on olds and news
        # - [old1, new1, ...] with AttrName coercions on olds and news
        #
        # @param [Object] arg the value to coerce to a Renaming
        def coerce(arg)
          case arg
          when Renaming
            arg
          when Hash
            Renaming.new Hash[arg.map{|k,v|
              [ Tools.coerce(k, AttrName),
                Tools.coerce(v, AttrName) ]
            }]
          when Array
            coerce(Hash[*arg])
          else
            raise ArgumentError, "Invalid argument `#{arg}` for Renaming()"
          end
        end
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

      # Returns the ordering hash code.
      #
      # @return [Integer] a hash code for this renaming
      def hash
        renaming.hash
      end

      # Checks equality with another Renaming instance.
      #
      # @param [Renaming] other another renaming instance
      # @return [Boolean] true if self and other are equal, false otherwise
      def ==(other)
        other.is_a?(Renaming) && (other.renaming == renaming)
      end
      alias :eql? :==

      # Returns a ruby literal for this renaming.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::Renaming[#{Tools.to_ruby_literal(renaming)}]"
      end
      alias :inspect :to_ruby_literal

    end # class Renaming
  end # module Types
end # module Alf
