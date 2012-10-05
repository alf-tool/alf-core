module Alf
  module Schema
    include Lang::Functional

    module ClassMethods

      def connect(conn_spec, &bl)
        Connection.connect(conn_spec, self, &bl)
      end

      def native(as, native_name = as)
        define_method(as) do
          Algebra::Operand::Named.new(context, native_name)
        end
      end

      def namespace(name, *schemas)
        define_method(name) do
          Lang::Lispy.new(context, schemas)
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
          if !args.empty? || bl || !context.known?(name)
            super
          else
            Algebra::Operand::Named.new(context, name)
          end
        end
      }
    end

  end # module Schema
end # module Alf