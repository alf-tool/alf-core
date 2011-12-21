module Alf
  module Command
    class Exec < Alf::Command()
      include Command
      
      def execute(args)
        Reader.alf(args.first || $stdin, requester.environment)
      end
      
    end # class Exec
  end # module Command
end # module Alf
