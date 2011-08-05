module Alf
  module Command
    class Help < Alf::Command()
      include Command
      
      # Let NoSuchCommandError be passed to higher stage
      no_react_to Quickl::NoSuchCommand
      
      # Command execution
      def execute(args)
        sup = Quickl.super_command(self)
        sub = (args.size != 1) ? sup : Quickl.sub_command!(sup, args.first)
        doc = Quickl.help(sub)
        puts doc
      end
      
    end # class Help
  end # module Command
end # module Alf
