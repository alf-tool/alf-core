module Alf
  module Viewpoint

    module ClassMethods

      def parser(connection = nil)
        Lang::Lispy.new([ self ], connection)
      end

      def parse(*args, &bl)
        parser.parse(*args, &bl)
      end

      def native(as, native_name = as)
        define_method(as) do
          Algebra.named_operand(native_name)
        end
      end

      def namespace(name, *viewpoints)
        define_method(name) do
          Lang::Lispy.new(viewpoints, connection)
        end
      end
    end
    extend ClassMethods

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    NATIVE = Module.new{
      include ::Alf::Viewpoint

      def method_missing(name, *args, &bl)
        (!args.empty? || bl) ? super : ::Alf::Algebra.named_operand(name)
      end
    }

  end # module Viewpoint
end # module Alf
