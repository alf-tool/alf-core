module Alf
  module CSV
    class Renderer < Alf::Renderer
      
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
      end
      
      private
      
      def get_csv(io, options = {})
        if RUBY_VERSION >= "1.9"
          require 'csv'
          ::CSV.new(io, options)
        else
          require 'faster_csv'
          ::FasterCSV.new(io, options)
        end
      end
      
      def extract_header(tuple)
        tuple.keys
      end
      
      def extract_row(tuple, header)
        header.collect{|k| tuple[k]}
      end
  
      Renderer.register(:csv, "as a csv file", self)
    end # class Renderer
  end # module CSV
end # module Alf