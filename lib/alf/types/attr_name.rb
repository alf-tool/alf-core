module Alf
  module Types
    #
    # Attribute name.
    #
    # Attribute names are ruby symbols that match the following regular expression:
    #
    #     /^[a-zA-Z0-9_]+[?!]?$/
    #
    # Example:
    #
    #     AttrName["city"]
    #     # => :city
    #
    class AttrName < Symbol
      extend Myrrha::Domain

      class << self

        # The domain predicate
        PREDICATE = lambda{|s| s.to_s =~ /^[a-zA-Z0-9_]+[?!]?$/}

        # Returns the domain predicate.
        #
        # @return [Proc] the domain predicate as a Proc obbject
        def predicate
          PREDICATE
        end

        # Coerces `arg` to an AttrName.
        #
        # All objects that respond to :to_sym and match PREDICATE are
        # valid coercion arguments.
        #
        # @param [Object] arg and argument to coerce to an AttrName
        # @return [AttrName] an AttrName instance
        # @raise [ArgumentError] is the coercion fails
        def coerce(arg)
          if arg.respond_to?(:to_sym)
            sym = arg.to_sym
            return sym if self.===(sym)
          end
          raise ArgumentError, "Unable to coerce `#{arg.inspect}` to AttrName"
        end
        alias :[] :coerce

        # Converts commandline arguments to an AttrName.
        #
        # This method requires `argv` to be either empty or a singleton array.
        # When empty, `opts[:default]` is used. The value must be coercable
        # with `coerce` for this method to suceed.
        #
        # @param [Array] argv commandline arguments
        # @params [Hash] opts options (not used)
        # @raise [ArgumentError] is the coercion fails
        def from_argv(argv, opts = {})
          raise ArgumentError if argv.size > 1
          coerce(argv.first || opts[:default])
        end

      end

    end # class AttrName
  end # module Types
end # module Alf
