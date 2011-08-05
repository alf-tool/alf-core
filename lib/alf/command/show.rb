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
      end
        
      def execute(args)
        requester.renderer = (@renderer || requester.renderer || Text::Renderer.new)
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

    end # class Show
  end # module Command
end # module Alf
