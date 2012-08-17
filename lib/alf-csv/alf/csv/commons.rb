module Alf
  module CSV
    #
    # Provides common tooling to CSV renderer and readers
    #
    module Commons

      DEFAULT_OPTIONS = {
        :headers => true
      }

      private

      # Returns a CSV instance bound to a given io and options
      def get_csv(io)
        ::CSV.new io, Alf::Tuple(options).project(::CSV::DEFAULT_OPTIONS.keys)
      end

    end # module Commons
  end # module CSV
end # module Alf
