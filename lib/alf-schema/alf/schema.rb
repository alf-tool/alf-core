module Alf
  module Schema

    module ClassMethods

      def parser
        Lang::Lispy.new([ self ])
      end

      def parse(*args, &bl)
        parser.parse(*args, &bl)
      end

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
    extend ClassMethods

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    NATIVE = Module.new{
      include ::Alf::Schema

      def method_missing(name, *args, &bl)
        (!args.empty? || bl) ? super : ::Alf::Algebra.named_operand(name)
      end
    }

  end # module Schema
end # module Alf
