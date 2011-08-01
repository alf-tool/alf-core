module Alf
  module Sequel
    
    #
    # Specialization of Alf::Environment to distribute Sequel datasets
    #
    class Environment < ::Alf::Environment
      
      #
      # (see Alf::Environment.recognizes?)
      #
      # Returns true if args contains one String that can be interpreted as
      # a valid database uri.
      #
      def self.recognizes?(args)
        require 'uri'
        return false unless (args.size == 1) && args.first.is_a?(String)
        uri = URI::parse(args.first)
        if uri.scheme || looks_a_sqlite_file?(args.first)
          true
        else
          false
        end
      rescue ::URI::Error
        false
      end
      
      def self.looks_a_sqlite_file?(f)
        (File.file?(f) && File.extname(f).==(".db"))
      end
      
      # Creates an Environment instance
      def initialize(uri, options = {})
        @uri = self.class.looks_a_sqlite_file?(uri) ? "sqlite://#{uri}" : uri
        @options = options
      end
      
      #
      # (see Alf::Environment#dataset)
      # 
      def dataset(name)
        Iterator.new(connect[name])
      end
      
      private 
      
      # Creates a database connection
      def connect
        Alf::Tools::friendly_require('sequel')
        @db ||= ::Sequel.connect(@uri, @options)
      end
      
      ::Alf::Environment.register(:sequel, self)
    end # class Environment
    
    # Specialization of Alg::Iterator to work on a Sequel dataset
    class Iterator
      include ::Alf::Iterator
      
      def initialize(dataset)
        @dataset = dataset
      end
      
      # (see Alf::Iterator#each)
      def each
        @dataset.each(&Proc.new)
      end
      
      # (see Alf::Iterator#pipe)
      def pipe(input, env = nil)
        self
      end
      
    end # class Iterator
    
  end # module Sequel
end # module Alf