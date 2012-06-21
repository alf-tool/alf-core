module Alf
  class Database

    class << self
      # Auto-detect the database to use for specific arguments.
      #
      # This method returns a database instance bound to an autodetected Adapter. It
      # raises an ArgumentError if no such adapter can be found.
      #
      # @param [Array] args arguments for the Adapter constructor
      # @return [Database] an database instance
      # @raise [ArgumentError] when no registered adapter recognizes the arguments
      def autodetect(*args)
        return args.first if args.size==1 && args.first.is_a?(Database)
        Database.new(Adapter.autodetect *args)
      end

      def folder(*args)
        Database.new(Adapter.folder *args)
      end

      # Returns Alf's default database
      #
      # @return [Database] the default database instance.
      def default
        Database.new(Adapter.folder '.')
      end

      # Returns a database instance on Alf's examples
      #
      # @return [Database] a database instance on Alf's examples.
      def examples
        Database.new(Adapter.folder Path.backfind('examples/operators'))
      end
    end

    attr_reader :lower_stage

    def initialize(lower_stage)
      @lower_stage = lower_stage
    end

    # Returns a dataset whose name is provided.
    #
    # This method resolves named datasets to tuple enumerables by passing the request to 
    # the lower stage. When the dataset exists, this method must return an Iterator. 
    # Otherwise, it throws a NoSuchDatasetError.
    #
    # @param [Symbol] name the name of a dataset
    # @return [Iterator] an iterator
    # @raise [NoSuchDatasetError] when the dataset does not exists
    def dataset(name)
      @lower_stage.dataset(name)
    end

  end # module Database
end # module Alf