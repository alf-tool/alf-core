module Alf
  module Types

    # Defines the Boolean type which is missing to ruby.
    Boolean = Myrrha::Boolean

    # Converts commandline arguments to a Boolean.
    #
    # This method requires `argv` to be either empty or a singleton array.
    # When empty, `opts[:default]` is used. The value must be coercable
    # to a Boolean, according to Myrrha::Boolean coercions.
    #
    # @param [Array] argv commandline arguments
    # @params [Hash] opts options (not used)
    # @raise [ArgumentError] is the coercion fails
    def Boolean.from_argv(argv, opts={})
      raise ArgumentError if argv.size > 1
      value = argv.first || opts[:default] || false
      Tools.coerce(value, Boolean)
    rescue CoercionError
      raise ArgumentError, "Unable to coerce `#{value.inspect}` to Boolean"
    end

  end
end
