module Alf
  module Text

    #
    # Implements Alf::Renderer for outputting beautiful text tables.
    #
    class Renderer < ::Alf::Renderer
  
      module Utils
  
        def looks_a_relation?(value)
          value.is_a?(Alf::Iterator) or
            (value.is_a?(Array) && !value.empty? && value.all?{|v| v.is_a?(Hash)})
        end
  
        def max(x, y)
          return y if x.nil?
          return x if y.nil?
          x > y ? x : y
        end
  
      end
      include Utils
  
      class Cell
        include Utils
  
        def initialize(value, options = {})
          @value = value
          @options = options
        end
  
        def min_width
          @min_width ||= rendering_lines.inject(0) do |maxl,line|
            max(maxl,line.size)
          end
        end
  
        def rendering_lines(size = nil)
          if size.nil?
            text_rendering.split(/\n/)
          elsif @value.is_a?(Numeric)
            rendering_lines(nil).collect{|l| "%#{size}s" % l}
          else
            rendering_lines(nil).collect{|l| "%-#{size}s" % l}
          end
        end
  
        def text_rendering
          @text_rendering ||= case (value = @value)
            when NilClass
              "[nil]"
            when Symbol
              value.inspect
            when Float
              (@options[:float_precision] || "%.3f") % value
            when Hash
              value.inspect
            when Alf::Iterator
              Text::Renderer.render(value, "")
            when Array
              array_rendering(value)
            else
              value.to_s
          end
        end
        
        def array_rendering(value)
          if looks_a_relation?(value) 
            Text.render(value, "")
          elsif value.empty?
            "[]"
          else
            values = value.collect{|x| Cell.new(x).text_rendering}
            if values.inject(0){|memo,s| memo + s.size} < 20
              "[" + values.join(", ") + "]"
            else
              "[" + values.join(",\n ") + "]"
            end 
          end
        end
  
      end # class Cell
  
      class Row
        include Utils        
  
        def initialize(values, options = {})
          @cells = values.collect{|v| Cell.new(v, options)}
          @options = options
        end
  
        def min_widths
          @cells.collect{|cell| cell.min_width}
        end
  
        def rendering_lines(sizes = min_widths)
          nb_lines = 0
          by_cell = @cells.zip(sizes).collect do |cell,size|
            lines = cell.rendering_lines(size)
            nb_lines = max(nb_lines, lines.size)
            lines
          end
          grid = (0...nb_lines).collect do |line_i|
            "| " + by_cell.zip(sizes).collect{|cell_lines, size|
              cell_lines[line_i] || " "*size
            }.join(" | ") + " |"
          end
          grid.empty? ? ["|  |"] : grid
        end
  
      end # class Row
  
      class Table
        include Utils
  
        def initialize(records, attributes, options = {})
          @header = Row.new(attributes)
          @rows = records.collect{|r| Row.new(r, options)}
          @options = options
        end
  
        def render(buffer = "")
          sizes = @rows.inject(@header.min_widths) do |memo,row|
            memo.zip(row.min_widths).collect{|x,y| max(x,y)}
          end
          sep = '+-' << sizes.collect{|s| '-' * s}.join('-+-') << '-+'
          buffer << sep << "\n"
          buffer << @header.rendering_lines(sizes).first << "\n"
          buffer << sep << "\n"
          @rows.each do |row|
            row.rendering_lines(sizes).each do |line|
              buffer << line << "\n"
            end
          end
          buffer << sep << "\n"
          buffer
        end
  
      end # class Table
  
      class PrettyBuffer 
        
        def initialize(out, options)
          @out = out
          @trim_at = options[:trim_at]
          @page_at = options[:page_at]
          @page_line = 0
        end

        def <<(str)
          print_a_line trim(str)
          self
        end

        def trim(str)
          return str unless (@trim_at && (str.length > @trim_at))
          trimmed = (str[0..(@trim_at-4)] + "...")
          trimmed << "\n" if str =~ /\n$/
          trimmed
        end

        def print_a_line(line)
          @out << line
          @page_line += 1
          do_wait if @page_at && (@page_line > @page_at)
        end

        def do_wait
          @out << "--- Press ENTER (or quit) ---\n"
          throw :stop if $stdin.getc =~ /^[qQ](uit)?/
          @page_line = 0
        end

      end # class PrettyBuffer

      protected
      
      def render(input, output)
        relation = input.to_a
        attrs    = relation.inject([]){|memo,t| (memo | t.keys)}
        records  = relation.collect{|t| attrs.collect{|a| t[a]}}
        table    = Table.new(records, attrs, options)
        buffer   = options[:pretty] ? 
                   PrettyBuffer.new(output, options) : output
        catch(:stop){ table.render(buffer) }
        output
      end
      
      def self.render(input, output)
        new(input).execute(output)
      end
      
      ::Alf::Renderer.register(:text, "as a text table",  self)
    end # class Renderer
    
  end # module Text
end # module Alf
