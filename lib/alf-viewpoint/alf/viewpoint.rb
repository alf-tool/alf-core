require_relative 'viewpoint/metadata'
module Alf
  module Viewpoint

    module ClassMethods

      def metadata
        @metadata ||= Metadata.new
      end

      def expects(*viewpoints)
        metadata.expects(viewpoints)
      end

      def depends(as, *viewpoints)
        metadata.depends(as => viewpoints)
      end

      def build(context = {})
        x = self
        metadata.to_module(context){ include(x) }
      end
      alias :[] :build

      def parser(connection = nil)
        Lang::Lispy.new([ self ], connection)
      end

      def parse(*args, &bl)
        parser.parse(*args, &bl)
      end

      def native(as, native_name = as)
        define_method(as) do
          Algebra.named_operand(native_name, connection)
        end
      end

      def members
        metadata.all_members
      end

      def method_added(m)
        super.tap{
          metadata.add_members([m]) if public_method_defined?(m)
        }
      end
    end
    extend ClassMethods

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    NATIVE = Module.new{
      include ::Alf::Viewpoint

      def method_missing(name, *args, &bl)
        (!args.empty? || bl) ? super : ::Alf::Algebra.named_operand(name, connection)
      end
    }

  end # module Viewpoint
end # module Alf
