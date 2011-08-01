module Alf
  module Command
    # 
    # Show help about a specific command
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} COMMAND
    #
    class Help < Factory::Command(__FILE__, __LINE__)
      include Command
      
      # Let NoSuchCommandError be passed to higher stage
      no_react_to Quickl::NoSuchCommand
      
      # Command execution
      def execute(args)
        sup = Quickl.super_command(self)
        sub = (args.size != 1) ? sup : Quickl.sub_command!(sup, args.first)
        puts Quickl.help(sub)
      end
      
    end # class Help
  end # module Command
end # module Alf
