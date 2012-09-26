module Alf
  module Types
    #
    # Defines a Size domain, as a (non strictly) positive integer.
    #
    class Size < Integer
      extend Myrrha::Domain::SByC.new(Integer, [], lambda{|i| i >= 0})

      coercions do |c|
        c.upon(Object){|s,t| new Support.coerce(s, Integer) }
      end

      class << self

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
