module Alf
  class Renderer
    class Html < Renderer

      def self.mime_type
        "text/html"
      end

      def each
        return to_enum unless block_given?
        yield "<table class=\"table table-condensed table-bordered table-striped\">"
        header = nil
        each_tuple do |tuple|
          unless header
            header = tuple.keys
            yield "<thead><tr>"
            header.each do |attrname|
              yield "<th>#{attrname}</th>"
            end
            yield "</tr></thead><tbody>"
          end
          yield "<tr>"
          header.each do |attrname|
            yield "<td>#{render_value tuple[attrname]}</td>"
          end
          yield "</tr>"
        end
        yield "</tbody></table>"
      end

      def self.render(input, output, options= {})
        new(input, options).execute(output)
      end

    private

      def render_value(value)
        case value
        when RelationLike
          Html.new(value).execute("")
        when ->(t){ t.is_a?(Array) && t.first && t.first.is_a?(Hash) }
          Html.new(value).execute("")
        else
          value.to_s
        end
      end

      ::Alf::Renderer.register(:html, "as an html table",  self)
    end # class Html
  end # class Renderer
end # module Alf
