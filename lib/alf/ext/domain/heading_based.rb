module Domain
  class HeadingBased < Module

    def initialize(master_class)
      define_method(:type){|heading|
        heading = Alf::Heading.coerce(heading)
        meths   = DomainMethods.new(master_class, heading)
        Class.new(master_class).extend(meths)
      }
      alias_method :[], :type
    end

    class DomainMethods < Module

      def initialize(master_class, heading)
        define_method(:heading){
          heading
        }
        define_method(:<=>){|other|
          return nil unless other.ancestors.include?(master_class)
          heading <=> other.heading
        }
        define_method(:===){|value|
          super(value) ||
          (value.is_a?(master_class) && value.heading == heading)
        }
        define_method(:hash){
          @hash ||= 37*master_class.hash + heading.hash
        }
        define_method(:==){|other|
          other.is_a?(Class) && other.superclass==master_class && other.heading==heading
        }
        define_method(:coerce){|arg|
          master_class.coercions.apply(arg, self)
        }
        define_method(:to_s){
          "#{master_class.name}.type(#{Alf::Support.to_ruby_literal(heading.to_hash)})"
        }
      end
    end # module DomainMethods
  end # module HeadingBased
end # module Domain