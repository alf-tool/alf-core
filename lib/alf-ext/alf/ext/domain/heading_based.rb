module Domain
  module HeadingBased

    def self.new(master_class)
      Module.new{
        define_method(:type){|heading|
          heading = Alf::Heading.coerce(heading)
          meths   = [
            DomainMethods.new(master_class, heading),
            Domain::Comparisons
          ]
          Class.new(master_class).extend(*meths)
        }
        alias_method :[], :type
      }
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
        define_method(:to_ruby_literal){
          "#{master_class.name}[#{Alf::Support.to_ruby_literal(heading.to_hash)}]"
        }
        alias_method :to_s, :to_ruby_literal
      end
    end # module DomainMethods
  end # module HeadingBased
end # module Domain