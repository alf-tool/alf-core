module Alf
  module Types
    #
    # Defines a Size domain, as a (non strictly) positive integer.
    #
    class Size < Integer
      extend Myrrha::Domain

      # The size predicate
      PREDICATE = lambda{|i| i >= 0}

      class << self

        # Returns the domain predicate.
        #
        # @return [Proc] the domain predicate as a Proc object
        def predicate
          PREDICATE
        end

        # Coerces `arg` to a size
        #
        # @param [Object] arg any value coercable to an Integer
        # @return [Size] the coerced size when success
        # @raise [ArgumentError] if the coercion fails
        def coerce(arg)
          res = Tools.coerce(arg, Integer)
          if self === res
            res
          else
            raise ArgumentError, "Invalid value `#{arg}` for Size()" 
          end
        rescue Alf::CoercionError
          raise ArgumentError, "Invalid value `#{arg}` for Size()"
        end

        # Coerces commandline arguments to a Size.
        #
        # The `argv` must be empty or a singleton. When empty, `opts[:default]`
        # is used, which defaults to 0.
        #
        # @param [Array<String>] argv commandline arguments
        # @param [Hash] opts coercion options
        # @return [Size] coerced size as specified on commandline
        # @raise [ArgumentError] if the size cannot be coerced from argv
        def from_argv(argv, opts = {:default => 0})
          if argv.size > 1
            raise ArgumentError, "Invalid value #{argv.inspect} for Size()" 
          end
          coerce(argv.first || opts[:default])
        end

      end # class << self

    end # Size
 end # module Types
end # module Alf
