module Alf
  module CSV
    #
    # Implements Alf::Renderer contract for outputting CSV files.
    #
    class Renderer < Alf::Renderer
      include CSV::Commons

    protected

      # (see Renderer#render)
      def render(input, output)
        csv = get_csv(output)
        header = nil
        input.each do |tuple|
          unless header
            header = tuple.keys
            csv << header.map(&:to_s)
          end
          csv << header.map{|k| tuple[k]}
        end
        output
      end

      Alf::Renderer.register(:csv, "in CSV", self)
    end # class Renderer
  end # module CSV
end # module Alf
