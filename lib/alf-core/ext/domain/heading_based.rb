module Domain
  class HeadingBased < Module

    def initialize(master_class)
      define_method(:new){|*args|
        raise "#{master_class}.new may not be called directly" if master_class==self
        super(*args)
      }
      define_method(:type){|generating_type={},&bl|
        clazz = Class.new(master_class)
        if bl
          generating_type = generating_type.to_heading.to_hash unless generating_type.is_a?(Hash)
          generating_type = generating_type.merge(bl.call(clazz))
        end
        meths = [
          DomainMethods.new(master_class, generating_type),
          AlgebraMethods.new(master_class, generating_type),
          Domain::Comparisons,
        ]
        clazz.extend(*meths).heading_based_factored
      }
      alias_method :[], :type
      define_method(:heading_based_factored) do
        self
      end
    end

    class DomainMethods < Module

      def initialize(master_class, gt)
        define_method(:generating_type){
          gt
        }
        define_method(:<=>){|other|
          return 0 if self == other
          return nil unless other.ancestors.include?(master_class)
          return -1 if other == master_class
          to_heading <=> other.to_heading
        }
        define_method(:===){|value|
          super(value) || (value.is_a?(master_class) && self >= value.class)
        }
        define_method(:hash){
          @hash ||= 37*master_class.hash + generating_type.hash
        }
        define_method(:==){|other|
          other.is_a?(Class) &&
          other.superclass==master_class &&
          other.to_heading==to_heading
        }
        define_method(:coerce){|arg|
          master_class.coercions.apply(arg, self)
        }
        define_method(:empty){
          new([].to_set)
        }
        define_method(:to_heading){
          @heading ||= Alf::Heading.coerce(generating_type)
        }
        define_method(:recursive?){
          h = to_heading
          h.to_attr_list.any?{|a| h[a] == self}
        }
        define_method(:to_ruby_literal){
          recursive? ?
            "#{master_class.name}[...]" :
            "#{master_class.name}[#{Alf::Support.to_ruby_literal(to_heading.to_hash)}]"
        }
        alias_method :name, :to_ruby_literal
        alias_method :to_s, :to_ruby_literal
        alias_method :inspect, :to_ruby_literal
      end
    end # module DomainMethods

    class AlgebraMethods < Module

      def initialize(master_class, generating_type)
        define_method(:heading){
          @heading ||= Alf::Heading.coerce(generating_type)
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