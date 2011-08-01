module Alf
  module Command
    # 
    # Output input tuples through a specific renderer (text, yaml, ...)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} DATASET
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #
    # When a dataset name is specified as commandline arg, request the 
    # environment to provide this dataset and prints it. Otherwise, take what 
    # comes on standard input.
    #
    # Note that this command is not an operator and should not be piped anymore.
    #
    class Show < Alf::Command(__FILE__, __LINE__)
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
