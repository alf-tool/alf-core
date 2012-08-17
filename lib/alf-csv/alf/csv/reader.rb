module Alf
  module CSV
    #
    # Implements Alf::Reader contract for reading CSV files.
    #
    class Reader < Alf::Reader
      include CSV::Commons

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
    end # class Reader
  end # module CSV
end # module Alf
