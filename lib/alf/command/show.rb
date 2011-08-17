module Alf
  module Command
    class Show < Alf::Command()
      include Command
    
      options do |opt|
        @renderer_class = nil
        Renderer.each_renderer do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){ 
            @renderer_class = clazz
          }
        end
        
        @pretty = nil
        opt.on("--[no-]pretty", 
               "Enable/disable pretty print best effort") do |val|
          @pretty = val
        end
      end
        
      def run(argv, requester)
        # set requester and parse options
        @requester = requester
        argv = parse_options(argv, :split)

        # Set options on the requester
        requester.pretty = @pretty unless @pretty.nil?
        requester.renderer_class = (@renderer_class || 
                                    requester.renderer_class || 
                                    Text::Renderer)

        # normalize args
        args = argv.first
        args = [ stdin_reader ] if args.empty?
        chain = args.first

        # put a sorter
        if argv[1]
          sorter = Alf::Operator::NonRelational::Sort.new(argv[1])
          chain  = sorter.pipe(chain, requester.environment)
        end

        chain
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
