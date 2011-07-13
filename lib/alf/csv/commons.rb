module Alf
  module CSV
    module Commons

      private
      
      def get_csv_options
        {:headers => true}
      end
      
      def get_csv_class
        if RUBY_VERSION >= "1.9"
          require 'csv'
          ::CSV
        else
          ::Alf::Tools::friendly_require('fastercsv')
          ::FasterCSV
        end
      end
      
      def get_csv(io, options = get_csv_options)
        get_csv_class.new(io, options)
      end
      
    end
  end
end