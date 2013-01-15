module Alf
  module Support

    # Defines all coercion rules, through Myrrha inheritance
    Coercions = Myrrha::Coerce.dup.append do |g|
      g.error_handler = lambda{|v,t,c|
        raise c if c
        raise TypeError, "Unable to coerce `#{v.inspect}` to `#{t}`", caller
      }
      g.coercion String, Time,     lambda{|s,t| Time.parse(s) }
      g.coercion String, DateTime, lambda{|s,t| DateTime.parse(s) }
    end

    # Coerces a value to a particular domain.
    #
    # Example:
    #
    #   Support.coerce("123", Integer) # => 123
    #
    # @param [Object] val any value
    # @param [Class] domain a domain, represented by a ruby class
    # @return [Object] an instance of `domain` resulting from the coercion
    # @raise [Myrrha::CoercionError] if something goes wrong
    def coerce(val, domain)
      Coercions.apply(val, domain)
    end

  end # module Support
end # module Alf
