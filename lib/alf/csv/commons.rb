module Alf
  module CSV
    module Commons

      def get_csv(io, options = {:headers => true})
        if RUBY_VERSION >= "1.9"
          require 'csv'
          ::CSV.new(io, options)
        else
          require 'faster_csv'
          ::FasterCSV.new(io, options)
        end
      end
      
    end
  end
end