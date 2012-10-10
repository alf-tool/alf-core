module Alf
  module Schema
    include Lang::Functional

    module ClassMethods

      def native(as, native_name = as)
        define_method(as) do
          Algebra.named_operand(native_name)
        end
      end

      def namespace(name, *schemas)
        define_method(name) do
          Lang::Lispy.new(schemas)
        end
      end
    end

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    def self.native
      Module.new{
        include ::Alf::Schema
        def method_missing(name, *args, &bl)
          (!args.empty? || bl) ? super : Algebra.named_operand(name)
        end
      }
    end

  end # module Schema
end # module Alf