module Alf
  module CSV
    class Renderer < Alf::Renderer
      
      # (see Renderer#render)
      def render(input, output)
        FasterCSV.open(output) do |csv|
          header = nil
          input.each do |tuple|
            unless header 
              header = extract_header(tuple)
              csv << header
            end
            csv << extract_row(tuple, header)
          end
        end
      end
      
      private
      
      def extract_header(tuple)
        tuple.keys.collect{|k| k.to_s}
      end
      
      def extract_row(tuple, header)
        header.collect{|k| tuple[k]}
      end
  
      Renderer.register(:csv, "as a csv file", self)
    end # class Renderer
  end # module CSV
end # module Alf