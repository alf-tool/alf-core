module Alf
  module Types
    class Selection
      extend Domain::Reuse.new(Object)

      coercions do |c|
        c.coercion(Symbol){|x,_|
          new(x)
        }
        c.coercion(String){|x,_|
          new(x.to_sym)
        }
        c.coercion(Array){|x,_|
          Selection.new(x.map{|y| Selector.coerce(y) })
        }
      end

      def select(tuple)
        return tuple[reused_instance] unless reused_instance.is_a?(Array)
        reused_instance.map{|s| s.select(tuple) }
      end

      def to_s
        reused_instance.to_s
      end

    end # class Selection
  end # module Types
end # module Alf