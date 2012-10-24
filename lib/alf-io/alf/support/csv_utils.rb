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
      def get_csv(io, options = {})
        require 'csv'
        ::CSV.new io, Tuple(options).project(::CSV::DEFAULT_OPTIONS.keys)
      end

      # Yields a CSV instance bound to a given io and options
      def with_csv(io, options = {})
        yield get_csv(io, options)
      end

      class ProcIO

        def initialize(proc = nil, &bl)
          @proc = proc || bl
        end

        def call(*args, &bl)
          @proc.call(*args, &bl)
        end
        alias :<< :call

      end # ProcIO

    end # module CSVUtils
  end # module Support
end # module Alf
