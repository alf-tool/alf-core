module Alf
  module Command
    # 
    # Executes an .alf file on current environment
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [FILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #
    # This command executes the .alf file passed as first argument (or what comes
    # on standard input) as a alf query to be executed on the current environment.
    #
    class Exec < Alf::Command(__FILE__, __LINE__)
      include Command
      
      def execute(args)
        Reader.alf(args.first || $stdin, requester.environment)
      end
      
    end # class Exec
  end # module Command
end # module Alf
