module Alf
  module CSV
    module Commons

      private
      
      # Attempt to require(who) the most friendly as possible
      def friendly_require(who, dep = nil, retried = false)
        gem(who, dep) if dep && defined?(Gem)
        require who
      rescue LoadError => ex
        if retried
          raise "Unable to require #{who}, which is now needed\n"\
                "Try 'gem install #{who}'"
        else
          require 'rubygems' unless defined?(Gem)
          friendly_require(who, dep, true)
        end
      end
    
      def get_csv_options
        {:headers => true}
      end
      
      def get_csv_class
        if RUBY_VERSION >= "1.9"
          require 'csv'
          ::CSV
        else
          friendly_require('fastercsv')
          ::FasterCSV
        end
      end
      
      def get_csv(io, options = get_csv_options)
        get_csv_class.new(io, options)
      end
      
    end
  end
end