module Alf
  module Iterator
    class Proxy
      include Iterator

      # @return [Symbol] name of the dataset to request to database
      attr_reader :name

      # Creates a proxy instance.
      #
      # @param [Database] db the database serving iterator instances
      # @param [Symbol] dataset named dataset to rely on
      def initialize(db, name)
        unless db.respond_to?(:dataset)
          raise ArgumentError, "Invalid database `#{db.inspect}`"
        end
        @database, @name = db, name
      end

      # (see Iterator#each)
      def each(&block)
        @database.dataset(@name).each(&block)
      end

    end # class Proxy
  end # module Iterator
end # module Alf
