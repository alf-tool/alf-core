module Alf
  module Sequel
    #
    # Specialization of Alf::Environment to distribute Sequel datasets
    #
    class Environment < ::Alf::Environment

      class << self

        # (see Alf::Environment.recognizes?)
        #
        # @return true if args contains one String that can be interpreted as
        # a valid database uri, false otherwise
        def recognizes?(args)
          require 'uri'
          if args.size == 1 and args.first.is_a?(String)
            uri = URI::parse(args.first)
            !!uri.scheme or looks_a_sqlite_file?(args.first)
          else
            false
          end
        rescue ::URI::Error
          false
        end

        # Returns trus if `f` looks like a sqlite file
        def looks_a_sqlite_file?(f)
          File.file?(f) and File.extname(f) == ".db"
        end

      end # class << self

      # Creates an Environment instance
      def initialize(uri, options = {})
        @uri = self.class.looks_a_sqlite_file?(uri) ? "sqlite://#{uri}" : uri
        @options = options
      end

      # (see Alf::Environment#dataset)
      def dataset(name)
        Iterator.new(connect[name])
      end

      private 

      # Creates a database connection
      def connect
        @db ||= begin
          Alf::Tools::friendly_require('sequel')
          ::Sequel.connect(@uri, @options)
        end
      end

      Alf::Environment.register(:sequel, self)
    end # class Environment
  end # module Sequel
end # module Alf
