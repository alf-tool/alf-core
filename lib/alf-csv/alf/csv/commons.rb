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

      # Returns CSV in ruby 1.9 and FasterCSV for ruby < 1.9.
      # This method handles require as well.
      def get_csv_class
        if RUBY_VERSION >= "1.9"
          require 'csv'
          ::CSV
        else
          ::Alf::Tools::friendly_require('fastercsv')
          ::FasterCSV
        end
      end

      # Returns a CSV instance bound to a given io and options
      def get_csv(io)
        csv_class = get_csv_class
        def_opts = csv_class.const_get(:DEFAULT_OPTIONS)
        csv_opts = options.delete_if{|k,v| !def_opts.has_key?(k)}
        csv_class.new(io, csv_opts)
      end

    end # module Commons
  end # module CSV
end # module Alf
