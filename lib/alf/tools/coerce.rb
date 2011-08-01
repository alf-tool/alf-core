module Alf
  module Tools

    # Coercion rules
    Coercions = Myrrha::Coerce.dup.append do
    end
    
    # Delegated to Coercions
    def coerce(value, domain)
      Coercions.apply(value, domain)
    end
    
  end # module Tools
end # module Alf