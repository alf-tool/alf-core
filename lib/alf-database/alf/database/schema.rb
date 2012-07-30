module Alf
  class Database
    class Schema

      attr_reader :database, :definition

      def initialize(database, definition)
        @database = database
        @definition = definition
      end

      def scope
        @database.scope [ definition ]
      end

    end # class Schema
  end # class Database
end # module Alf