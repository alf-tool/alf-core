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

    # Compiles a query expression given by a String or a block and returns the result 
    # (typically a tuple iterator)
    #
    # Example
    #
    #   # with a string
    #   op = db.compile "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   op = db.compile {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    #
    # @param [String] expr a Lispy expression to compile
    # @return [Iterator] the iterator resulting from compilation
    def compile(expr = nil, path = nil, line = nil, &block)
      lispy.evaluate(expr, path, line, &block)
    end

    # Evaluates a query expression given by a String or a block and returns
    # the result as an in-memory relation (Alf::Relation)
    #
    # Example:
    #
    #   # with a string
    #   rel = evaluate "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   rel = evaluate {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    def evaluate(expr = nil, path = nil, line = nil, &block)
      c = compile(expr, path, line, &block)
      c.respond_to?(:to_relation) ? c.to_relation : c
    end

    # Runs a command as in shell.
    #
    # Example:
    #
    #     Alf::Database.examples.run(['restrict', 'suppliers', '--', "city == 'Paris'"])
    #
    def run(argv, requester = nil)
      argv = Quickl.parse_commandline_args(argv) if argv.is_a?(String)
      argv = Quickl.split_commandline_args(argv, '|')
      argv.inject(nil) do |cmd,arr|
        arr.shift if arr.first == "alf"
        main = Alf::Shell::Main.new(self)
        main.stdin_reader = cmd unless cmd.nil?
        main.run(arr, requester)
      end
    end

    private

      def lispy
        Lang::Lispy.new(self)
      end

  end # module Database
end # module Alf