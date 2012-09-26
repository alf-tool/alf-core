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
      extend Myrrha::Domain::SByC.new(Symbol, [], lambda{|s| s.to_s =~ /^[a-zA-Z0-9_]+[?!]?$/})

      coercions do |c|
        c.delegate(:to_sym){|v,_| new(v.to_sym) }
      end

      class << self

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
        rescue Myrrha::Error => ex
          raise ArgumentError, ex.message
        end

      end

    end # class AttrName
  end # module Types
end # module Alf
