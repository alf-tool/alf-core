module Alf
  module Shell
    class Help < Shell::Command()
      
      # Let NoSuchCommandError be passed to higher stage
      no_react_to Quickl::NoSuchCommand
      
      options do |opt|
        @dialect = :shell
        opt.on('--lispy', 
               'Display operator signatures in lispy DSL') do
          @dialect = :lispy
        end
        opt.on('--shell', 
               'Display operator signatures in shell DSL') do
          @dialect = :shell
        end
      end

      # Command execution
      def execute(args)
        sup = Quickl.super_command(self)
        sub = (args.size != 1) ? sup : Quickl.sub_command!(sup, args.first)
        doc = sub.documentation(:method => @dialect)
        puts doc
      end
      
    end # class Help
  end # module Shell
end # module Alf
