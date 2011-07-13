module Alf
  module CSV
    class Reader < Alf::Reader
      include CSV::Commons
      
      def each
        with_input_io do |io|
          header = nil
          get_csv(io).each do |row|
            next if row.header_row?
            yield(row.to_hash)
          end
        end
      end
      
      Reader.register(:csv, [".csv"], self)
    end # class Reader
  end # module CSV
end # module Alf