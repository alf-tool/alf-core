module Alf
  module CSV
    class Reader < Alf::Reader
      include CSV::Commons
      
      def each
        with_input_io do |io|
          header = nil
          block = Proc.new{|row|
            next if row.header_row?
            yield(symbolize_keys(row.to_hash))
          }
          case io
          when StringIO
            get_csv_class.parse(io.string, get_csv_options, &block) 
          else
            get_csv(io).each(&block)
          end
        end
      end
      
      private
      
      def symbolize_keys(h)
        Hash[h.collect{|k,v| [k.to_sym,v] }]
      end
      
      ::Alf::Reader.register(:csv, [".csv"], self)
    end # class Reader
  end # module CSV
end # module Alf