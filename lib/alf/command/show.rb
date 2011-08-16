module Alf
  module Command
    class Show < Alf::Command()
      include Command
    
      options do |opt|
        @renderer = nil
        Renderer.each_renderer do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){ 
            @renderer = clazz.new 
          }
        end

        @pretty = false
        opt.on("--[no-]pretty", 
               "Enable/disable pretty print based on console inference") do |val|
          @pretty = val
        end
      end
        
      def execute(args)
        requester.renderer = (@renderer || 
                              requester.renderer || 
                              Text::Renderer.new(rendering_options))
        args = [ stdin_reader ] if args.empty?
        args.first
      end
    
      private 

      def stdin_reader
        if requester && requester.respond_to?(:stdin_reader)
          requester.stdin_reader
        else 
          Reader.coerce($stdin)
        end
      end

      def rendering_options
        opts = {:pretty => @pretty}
        if @pretty && (hl = highline)
          opts[:trim_at] = hl.output_cols
          opts[:page_at] = hl.output_rows
        end
        opts
      end

      def highline
        require 'highline'
        HighLine.new($stdin, $stdout)
      rescue LoadError => ex
        nil
      end

    end # class Show
  end # module Command
end # module Alf
