module Alf
  class Renderer
    class Text < Renderer

      def self.mime_type
        "text/plain"
      end

      module Utils

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
            rendering_lines(nil).map{|l| "%#{size}s" % l}
          else
            rendering_lines(nil).map{|l| "%-#{size}s" % l}
          end
        end

        def text_rendering
          @text_rendering ||= case (value = @value)
            when NilClass
              "[nil]"
            when Symbol
              value.inspect
            when Float
              (@options[:float_format] || "%.3f") % value
            when Hash
              value.inspect
            when RelationLike
              Text.render(value, "", @options)
            when Array
              array_rendering(value)
            when Time, DateTime
              value.to_s
            else
              value.to_s
          end
        end

        def array_rendering(value)
          if TupleLike===value.first
            Text.render(value, "")
          elsif value.empty?
            "[]"
          else
            values = value.map{|x| Cell.new(x).text_rendering}
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
          @cells = values.map{|v| Cell.new(v, options)}
          @options = options
        end

        def min_widths
          @cells.map{|cell| cell.min_width}
        end

        def rendering_lines(sizes = min_widths)
          nb_lines = 0
          by_cell = @cells.zip(sizes).map do |cell,size|
            lines = cell.rendering_lines(size)
            nb_lines = max(nb_lines, lines.size)
            lines
          end
          grid = (0...nb_lines).map do |line_i|
            "| " + by_cell.zip(sizes).map{|cell_lines, size|
              cell_lines[line_i] || " "*size
            }.join(" | ") + " |"
          end
          grid.empty? ? ["|  |"] : grid
        end

      end # class Row

      class Table
        include Utils

        def initialize(records, attributes, options = {})
          @header  = Row.new(attributes)
          @rows    = records.map{|r| Row.new(r, options)}
          @options = options
        end
        attr_reader :header, :rows, :options

        def sizes
          @sizes ||= rows.inject(header.min_widths) do |memo,row|
            memo.zip(row.min_widths).map{|x,y| max(x,y)}
          end
        end

        def sep
          @sep ||= '+-' << sizes.map{|s| '-' * s}.join('-+-') << '-+'
        end

        def each_line(pretty = options[:pretty])
          if pretty
            trim = options[:trim_at]
            each_line(false) do |line|
              yield(line[0..trim])
            end
          else
            yield(sep)
            yield(header.rendering_lines(sizes).first)
            yield(sep)
            rows.each do |row|
              row.rendering_lines(sizes).each do |line|
                yield(line)
              end
            end
            yield(sep)
          end
        end

        def each
          return to_enum unless block_given?
          each_line do |line|
            yield(line.strip << "\n")
          end
        end

        def to_s
          each.each_with_object(""){|line,buf| buf << line}
        end

      end # class Table

      def each(&bl)
        input    = self.input
        input    = [input.to_hash] if TupleLike===input
        relation = input.to_a
        attrs    = relation.inject([]){|memo,t| (memo | t.keys)}
        records  = relation.map{|t| attrs.map{|a| t[a]}}
        table    = Table.new(records, attrs, options)
        table.each(&bl)
      end

      def self.render(input, output, options= {})
        new(input, options).execute(output)
      end

      ::Alf::Renderer.register(:text, "as a text table",  self)
    end # class Text
  end # class Renderer
end # module Alf
