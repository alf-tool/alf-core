module Alf
  module Sequel
    
    #
    # Specialization of Alf::Environment to distribute Sequel datasets
    #
    class Environment < ::Alf::Environment
      
      # Creates an Environment instance
      def initialize(uri, options = {})
        @uri = uri
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