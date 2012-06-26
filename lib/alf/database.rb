module Alf
  class Database

    class << self
      private :new

      # Connects to a database, auto-detecting the adapter to use.
      #
      # This method returns a database instance bound to an autodetected Adapter. It
      # raises an ArgumentError if no such adapter can be found.
      #
      # @param [Array] args arguments for the Adapter constructor
      # @return [Database] an database instance
      # @raise [ArgumentError] when no registered adapter recognizes the arguments
      def connect(*args)
        return args.first if args.size==1 && args.first.is_a?(Connection)
        return Connection.new(nil, helpers) if args.empty?
        return Connection.new(Adapter.autodetect(*args), helpers)
      end

      def folder(*args)
        connect(Adapter.folder *args)
      end

      # Returns Alf's default database
      #
      # @return [Database] the default database instance.
      def default
        connect(Adapter.folder '.')
      end

      # Returns a database instance on Alf's examples
      #
      # @return [Database] a database instance on Alf's examples.
      def examples
        connect(Adapter.folder Path.backfind('examples/operators'))
      end

      # Returns the array of helper modules to use for defining the evaluation
      # scope.
      #
      # @return [Array<Module>] helper modules for evaluation scope.
      def helpers(*helpers, &inline)
        @helpers ||= (superclass.helpers.dup rescue [])
        @helpers << Module.new(&inline) if inline
        @helpers += helpers
      end
    end

    helpers Lang

  end # module Database
end # module Alf