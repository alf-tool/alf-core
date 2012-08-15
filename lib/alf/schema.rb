module Alf
  module Schema
    include Lang::Functional

    module ClassMethods

      def connect(conn_spec, &bl)
        Connection.connect(conn_spec, self, &bl)
      end
    end

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    def self.native
      Module.new{
        include ::Alf::Schema

        def method_missing(name, *args, &bl)
          return super unless args.empty? and bl.nil?
          context.known?(name) ? var_ref(name) : super
        end
      }
    end

  end # module Schema
end # module Alf