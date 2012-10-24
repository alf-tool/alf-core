module Alf
  class Reader
    #
    # Implements Alf::Reader contract for reading CSV files.
    #
    class CSV < Reader
      include Support::CSVUtils

      def self.mime_type
        "text/csv"
      end

      def each
        return to_enum unless block_given?
        with_input_io do |io|
          block = Proc.new{|row|
            next if row.header_row?
            yield(::Alf::Support.symbolize_keys(row.to_hash))
          }
          csv_input = io.is_a?(StringIO) ? io.string : io
          get_csv(csv_input, options).each(&block)
        end
      end

      Alf::Reader.register(:csv, [".csv"], self)
    end # class CSV
  end # class Reader
end # module Alf
