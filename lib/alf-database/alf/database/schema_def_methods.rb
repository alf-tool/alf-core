module Alf
  class Database
    module SchemaDefMethods

      # Inform the schema to import native relation variables under public module
      # methods.
      def import_native_relvars
        @native_module = Module.new{
          # Implementation is a bit complex here because those relation variables
          # are not known at declaration time. Therefore, the strategy is to dynamically 
          # extend Lispy scopes that include this schema... Those scopes are extended by
          # explicit calls to Module.extend_object (see Scope implementation). So we
          # first register a singleton method to capture such call.
          def extend_object(obj)
            res = super(obj)
            # Now, we know that `obj` is a Lispy scope. That scope has a `context` that
            # should be a Connection object. We get the native schema and install it on
            # the original scope, provided it exists :-)
            if n = obj.context.native_schema_def
              n.to_scope_module.send(:extend_object, obj)
            end
            res
          end
        }
        self
      end
      attr_reader :native_module

      def default_schemas
        {}
      end

      # Returns the defined schemas (by name in a Hash)
      def schemas
        @schemas ||= Hash[default_schemas.map{|name,s| [name, s.dup] }]
      end

      # Create a named schema through a definition
      def schema(name, &defn)
        if defn
          schemas[name] ||= SchemaDef.new(self)
          schemas[name].define(&defn)
        else
          schemas[name].tap{|s| raise NoSuchSchemaError, "No such schema `#{name}`" unless s }
        end
      end

      # Returns the defined relvars
      def relvars
        @relvars ||= {}
      end

      # Creates a relvar with a query definition
      def relvar(name, &defn)
        relvars[name] = defn
      end

      def default_helpers
        []
      end

      # Returns the array of helper modules to use for defining the evaluation scope.
      def helpers(*helpers, &inline)
        @helpers ||= default_helpers
        unless helpers.empty? and inline.nil?
          @helpers << Module.new(&inline) if inline
          @helpers += helpers
        end
        @helpers
      end

      def to_scope_module
        me  = self
        mod = Module.new{
          extend(me.native_module) if me.native_module
          me.helpers.each{|m| 
            include(m)
          }
          me.schemas.each_pair do |name, defn|
            define_method(name){ defn.scope(context) }
          end
          me.relvars.each_pair do |name, defn|
            defn ||= lambda{ Operator::VarRef.new(context, name) }
            define_method(name, &defn)
          end
        }
        mod
      end

      def dup
        super.tap{|copy|
          copy.relvars = copy.relvars.dup
          copy.schemas = Hash[copy.schemas.map{|name,s| [name, s.dup] }]
          copy.helpers = copy.helpers.dup
        }
      end

    protected

      attr_writer :schemas
      attr_writer :relvars
      attr_writer :helpers

    end # module SchemaDefMethods
  end # class Database
end # module Alf