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
    #     AttrName.coerce("city")
    #     # => :city
    #
    class AttrName < Symbol
      extend Domain::SByC.new(Symbol){|s| s.to_s =~ /^[a-zA-Z0-9_]+[?!]?$/}

      coercions do |c|
        c.delegate(:to_sym){|v,_| new(v.to_sym) }
      end

    end # class AttrName
  end # module Types
end # module Alf
