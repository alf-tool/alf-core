module Alf
  class Adapter
    class Connection
      class SchemaCached < Connection

        def self.empty_cache
          Hash.new{|h,k| h[k] = {}}
        end

        def initialize(connection, cache = nil)
          @connection = connection
          @cache      = cache || SchemaCached.empty_cache
        end

        Connection.instance_methods(false).each do |meth|
          define_method(meth) do |*args, &bl|
            @connection.send(meth, *args, &bl)
          end
        end

        [ :knows?, :heading, :keys ].each do |meth|
          define_method(meth) do |name|
            @cache[meth][name] ||= @connection.send(meth, name)
          end
        end

        def to_s
          "#{@connection.to_s} (with cache)"
        end

      end # class SchemaCached
    end # class Connection
  end # class Database
end # module Alf
