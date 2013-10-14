module Alf
  module Types
    #
    # Defines a Size domain, as a (non strictly) positive integer.
    #
    class Size < Integer
      extend Domain::SByC.new(Integer){|i| i >= 0}

      coercions do |c|
        c.upon(Object){|s,t| new Support.coerce(s, Integer) }
      end

    end # Size
 end # module Types
end # module Alf
