module Alf
  module Shell
    class Show < Shell::Command()

      options do |opt|
        @renderer_class = nil
        Renderer.each do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){
            @renderer_class = clazz
          }
        end

        @pretty = nil
        opt.on("--[no-]pretty",
               "Enable/disable pretty print best effort") do |val|
          @pretty = val
        end

        @ff = nil
        opt.on("--ff=FORMAT",
               "Specify the floating point format") do |val|
          @ff = val
        end
      end

      def run(argv, requester)
        # set requester and parse options
        @requester = requester
        argv = parse_options(argv, :split)

        # Set options on the requester
        requester.pretty = @pretty unless @pretty.nil?
        requester.rendering_options[:float_format] = @ff unless @ff.nil?
        requester.renderer_class = (@renderer_class || requester.renderer_class)

        compile(argv)
      end

      def compile(argv)
        operand = operands(argv.shift, 1).last
        unless argv.empty?
          operand = Algebra::Sort.new([operand], Shell.from_argv(argv.first, Ordering))
        end
        operand
      end

    end # class Show
  end # module Shell
end # module Alf
