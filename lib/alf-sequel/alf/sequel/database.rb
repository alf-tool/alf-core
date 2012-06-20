module Alf
  module Sequel
    #
    # Specialization of Alf::Database to distribute Sequel datasets
    #
    class Database < ::Alf::Database

      class << self

        # (see Alf::Database.recognizes?)
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

      # Creates an Database instance
      def initialize(uri, options = {})
        @uri = self.class.looks_a_sqlite_file?(uri) ? "#{sqlite_protocol}://#{uri}" : uri
        @options = options
      end

      def sqlite_protocol
        defined?(JRUBY_VERSION) ? "jdbc:sqlite" : "sqlite"
      end

      # (see Alf::Database#dataset)
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

      Alf::Database.register(:sequel, self)
    end # class Database
  end # module Sequel
end # module Alf
