module Alf
  module Sequel
    #
    # Specialization of Alf::Adapter to distribute Sequel datasets
    #
    class Adapter < ::Alf::Adapter

      class << self

        # (see Alf::Adapter.recognizes?)
        #
        # @return true if args contains one String that can be interpreted as
        # a valid database uri, false otherwise
        def recognizes?(args)
          return false unless args.size == 1
          case arg = args.first
            when String
              require 'uri'
              uri = URI::parse(arg) rescue nil
              (uri && uri.scheme) or looks_a_sqlite_file?(arg)
            when Hash
              arg = Tools.symbolize_keys(arg)
              arg[:adapter] && arg[:database]
            else
              looks_a_sqlite_file?(arg)
          end
        end

        # Returns trus if `f` looks like a sqlite file
        def looks_a_sqlite_file?(f)
          return false unless Tools.pathable?(f)
          path = Tools.to_path(f)
          path.file? and ['db', 'sqlite', 'sqlite3'].include?(path.ext)
        end

        def sqlite_protocol
          defined?(JRUBY_VERSION) ? "jdbc:sqlite" : "sqlite"
        end

      end # class << self

      # Creates an Adapter instance
      def initialize(uri, options = {})
        @uri = if self.class.looks_a_sqlite_file?(uri)
          "#{self.class.sqlite_protocol}://#{uri}"
        else
          uri
        end
        @options = options
      end

      # (see Alf::Adapter#relvar)
      def relvar(name)
        with_connection do |c|
          raise NoSuchRelvarError,
                "No such table `#{name}`" unless c.table_exists?(name)
        end
        Relvar.new(self, name)
      end

      def ping
        connect.test_connection
      end

      def with_connection
        yield(connect)
      end

    private

      # Creates a database connection
      def connect
        @db ||= begin
          Alf::Tools::friendly_require('sequel')
          ::Sequel.connect(@uri, @options)
        end
      end

      Alf::Adapter.register(:sequel, self)
    end # class Adapter
  end # module Sequel
end # module Alf
