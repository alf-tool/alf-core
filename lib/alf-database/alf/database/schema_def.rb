module Alf
  class Database
    class SchemaDef
      include SchemaDefMethods

      # Creates a schema definition instance inside a given parent
      def initialize(parent = Class.new(Alf::Database), &bl)
        @parent = parent
        define(&bl) if bl
      end

      def database
        @parent.is_a?(SchemaDef) ? @parent.database : @parent
      end

      def define(&bl)
        instance_exec(&bl)
        self
      end

      def scope(database, with = [])
        @parent.scope(database, [ to_scope_module ] + with)
      end

    end # class SchemaDef
  end # class Database
end # module Alf