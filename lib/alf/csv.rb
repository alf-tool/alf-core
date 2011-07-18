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
      
      #
      # Returns CSV in ruby 1.9 and FasterCSV for ruby < 1.9.
      # This method handles require as well.
      #
      def get_csv_class
        if RUBY_VERSION >= "1.9"
          require 'csv'
          ::CSV
        else
          ::Alf::Tools::friendly_require('fastercsv')
          ::FasterCSV
        end
      end
      
      #
      # Returns a CSV instance bound to a given io and options
      #
      def get_csv(io)
        get_csv_class.new(io, options)
      end
      
    end # module Commons
    
    #
    # Implements Alf::Renderer contract for outputting CSV files. 
    #
    class Renderer < Alf::Renderer
      include CSV::Commons
      
      protected
      
      def options
        DEFAULT_OPTIONS
      end
      
      # (see Renderer#render)
      def render(input, output)
        csv = get_csv(output)
        header = nil
        input.each do |tuple|
          unless header 
            header = extract_header(tuple)
            csv << header.collect{|k| k.to_s}
          end
          csv << extract_row(tuple, header)
        end
        output
      end
      
      private
      
      def extract_header(tuple)
        tuple.keys
      end
      
      def extract_row(tuple, header)
        header.collect{|k| tuple[k]}
      end
  
      ::Alf::Renderer.register(:csv, "as a csv file", self)
    end # class Renderer
    
    #
    # Implements Alf::Reader contract for reading CSV files.
    #
    class Reader < Alf::Reader
      include CSV::Commons
      
      def each
        with_input_io do |io|
          block = Proc.new{|row|
            next if row.header_row?
            yield(symbolize_keys(row.to_hash))
          }
          case io
          when StringIO
            get_csv_class.parse(io.string, options, &block) 
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