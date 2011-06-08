begin
  require "gnuplot"
rescue LoadError
  require "rubygems"
  require "gnuplot"
end 
class Alf
  class Renderer
    class Plot < Renderer

      def self.to_data(rel)
        [rel.collect{|t| t[:x]}, rel.collect{|t| t[:y]}]
      end

      def self.to_dataset(tuple)
        ds = Gnuplot::DataSet.new(to_data(tuple[:data]))
        ds.with = "linespoints"
        tuple.each_pair do |k,v|
          next if k == :data
          if ds.respond_to?(:"#{k}=")
            ds.send(:"#{k}=", v)
          end 
        end
        ds
      end

      def self.to_plot(graph)
        Gnuplot::Plot.new do |plot|
          graph.each_pair do |k,v|
            next if k == :datasets
            plot.set(k.id2name, v)
          end
          plot.data = graph[:datasets].collect{|d| to_dataset(d)}
        end
      end

      def self.render(graph, io = $stdout)
        case graph
          when Hash
            io << to_plot(graph).to_gplot << "\n"
          when Array
            graph.each{|t| render(t, io)}
        end
      end

    end # class Plot
  end # class Renderer
end # module Alf
