module Alf
  class Renderer
    #
    # Implements Alf::Renderer contract for outputting CSV files.
    #
    class CSV < Renderer
      include Support::CSVUtils

      def each(&bl)
        return to_enum unless block_given?
        with_csv(ProcIO.new(bl), options) do |csv|
          header = nil
          input.each do |tuple|
            unless header
              header = tuple.keys
              csv << header.map(&:to_s)
            end
            csv << header.map{|k| tuple[k]}
          end
        end
      end

      Alf::Renderer.register(:csv, "in CSV", self)
    end # class CSV
  end # class Renderer
end # module Alf
