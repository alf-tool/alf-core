module Alf
  module Shell
    class Exec < Shell::Command()
      include Command
      
      def execute(args)
        Reader.alf(args.first || $stdin, requester.environment)
      end
      
    end # class Exec
  end # module Shell
end # module Alf
