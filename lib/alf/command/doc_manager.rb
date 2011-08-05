module Alf
  module Command
    class DocManager

      # Main documentation folder
      DOC_FOLDER = File.expand_path('../../../../doc/', __FILE__)

      #
      # Called by Quickl when it's time to generate documentation of `cmd`.
      # 
      def call(cmd, options = {})
        if File.exists?(file = find_file(cmd))
          text = File.read(file)
          cmd.instance_eval("%Q{#{text}}", file, 0)
        else
          "Sorry, no documentation available for #{cmd.command_name}"
        end
      end

      private 

      def find_file(cmd)
        where = if cmd.command?
          "commands"
        elsif cmd.operator? && cmd.relational?
          File.join("operators", "relational")
        elsif cmd.operator? && cmd.non_relational?
          File.join("operators", "non_relational")
        else 
          raise "Unexpected command #{cmd}"
        end
        File.join(DOC_FOLDER, where, "#{cmd.command_name}.md")
      end

    end # class DocManager
  end # module Command
end # module Alf
