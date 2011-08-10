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

          # Replace occurences of #{signature} to #{signature.to_xxx}
          # according to options
          method = (options[:method] || "shell").to_s
          text = text.gsub('#{signature}', '#{signature.to_' + method + '}')

          # Replace occurences of #{...} on single lines
          text = text.gsub(/^([ \t]*)#\{([^\}]+)\}/){|match| 
            spacing, invocation  = $1, $2
            res = cmd.instance_eval(invocation).to_s
            realign(res, spacing, true)
          }

          # Replace occurences of #{...} in other places
          text = text.gsub(/#\{([^\}]+)\}/){|match| 
            cmd.instance_eval($1).to_s
          }

          # Replace occurences of !{...} by the execution of the example
          text = text.gsub(/^([ \t]*)!\{([^\}]+)\}/){|match| 
            spacing, invocation  = $1, $2
            args = Quickl.parse_commandline_args(invocation)[1..-1]
            op   = Alf.lispy(Alf::Environment.examples).run(args)
            res  = op.to_rel.to_s
            res  = realign(res, spacing, false)[0...-1]
            if options[:method] == :lispy
              invocation = Tools.to_lispy(op)
            end
            realign("$ #{invocation}\n\n#{res}", spacing, false)
          }

        else
          "Sorry, no documentation available for #{cmd.command_name}"
        end
      end

      private 

      def realign(txt, spacing, strip)
        rx = strip ? /^[ \t]*/ : /^/
        txt.gsub(rx, spacing)
      end

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
