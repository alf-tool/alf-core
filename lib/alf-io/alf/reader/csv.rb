module Alf
  class Reader
    #
    # Implements Alf::Reader contract for reading CSV files.
    #
    class CSV < Reader
      include Support::CSVUtils

      def each
        with_input_io do |io|
          block = Proc.new{|row|
            next if row.header_row?
            yield(::Alf::Support.symbolize_keys(row.to_hash))
          }
          get_csv(io.is_a?(StringIO) ? io.string : io).each(&block)
        end
      end

      Alf::Reader.register(:csv, [".csv"], self)
    end # class CSV
  end # class Reader
end # module Alf
