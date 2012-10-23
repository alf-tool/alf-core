module Domain
  class HeadingBased < Module

    def initialize(master_class)
      define_method(:new){|*args|
        raise "#{master_class}.new may not be called directly" if master_class==self
        super(*args)
      }
      define_method(:type){|heading|
        heading = Alf::Heading.coerce(heading)
        meths   = [
          DomainMethods.new(master_class, heading),
          AlgebraMethods.new(master_class, heading),
          Domain::Comparisons,
        ]
        Class.new(master_class).extend(*meths)
      }
      alias_method :[], :type
    end

    class DomainMethods < Module

      def initialize(master_class, heading)
        define_method(:<=>){|other|
          return nil unless other.ancestors.include?(master_class)
          heading <=> other.heading
        }
        define_method(:===){|value|
          super(value) || (value.is_a?(master_class) && self >= value.class)
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

    class AlgebraMethods < Module

      def initialize(master_class, heading)
        define_method(:heading){
          heading
        }
        define_method(:split){|attr_list|
          if attr_list.empty?
            [ master_class::DUM.class, self ]
          elsif attr_list==heading.to_attr_list
            [ self, master_class::DUM.class ]
          else
            heading.split(attr_list).map{|h| master_class[h]}
          end
        }
        define_method(:project){|attr_list|
          split(attr_list).first
        }
        define_method(:allbut){|attr_list|
          split(attr_list).last
        }
        define_method(:rename){|renaming|
          master_class[heading.rename(renaming)]
        }
      end
    end
  end # module HeadingBased
end # module Domain