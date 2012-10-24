module Alf
  module Support
    #
    # Provides common tooling to CSV renderer and readers
    #
    module CSVUtils

      DEFAULT_OPTIONS = {
        :headers => true
      }

      private

      # Returns a CSV instance bound to a given io and options
      def get_csv(io)
        require 'csv'
        ::CSV.new io, Tuple(options).project(::CSV::DEFAULT_OPTIONS.keys)
      end

    end # module CSVUtils
  end # module Support
end # module Alf
