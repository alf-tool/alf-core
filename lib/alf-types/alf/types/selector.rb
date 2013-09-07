module Alf
  module Types
    class Selector
      extend Domain::SByC.new(Object){|o|
        AttrName===o or 
        (o.is_a?(Array) and o.all?{|v| AttrName===v })
      }

      coercions do |c|
        c.coercion(String){|v,_|
          v =~ /\./ ? c.coerce(v.split('.')) : AttrName.coerce(v)
        }
        c.coercion(Array){|v,_|
          v.map{|v| AttrName.coerce(v) }
        }
      end

    end # class Selector
  end # module Types
end # module Alf
