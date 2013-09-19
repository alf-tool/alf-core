module Alf
  module Types
    class Selector
      extend Domain::Reuse.new(Object)

      coercions do |c|
        c.coercion(Symbol){|v,_|
          Selector.new(AttrName.coerce(v))
        }
        c.coercion(String){|v,_|
          v =~ /\./ ? c.coerce(v.split('.')) : c.coerce(v.to_sym)
        }
        c.coercion(Array){|v,_|
          Selector.new(v.map{|v| AttrName.coerce(v) })
        }
      end

      def outcoerce
        reused_instance
      end

      def select(tuple)
        return tuple[reused_instance] unless reused_instance.is_a?(Array)
        reused_instance.inject(tuple){|t,a| t && t[a] }
      end

      def dive(attr)
        components = to_a
        return nil unless (components.first == attr) && components.size > 1
        rest  = components[1..-1]
        Selector.new(rest.size == 1 ? rest.first : rest)
      end

      def to_a
        Array(reused_instance)
      end

      def to_lispy
        Support.to_ruby_literal(reused_instance)
      end

      def to_ruby_literal
        "Alf::Selector[#{Support.to_ruby_literal(reused_instance)}]"
      end

      alias :to_s :to_ruby_literal
      alias :inspect :to_ruby_literal

    end # class Selector
  end # module Types
end # module Alf
