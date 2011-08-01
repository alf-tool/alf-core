module Alf
  module Command
    #
    # alf - Classy data-manipulation dressed in a DSL (+ commandline)
    #
    # SYNOPSIS
    #   alf [--version] [--help] 
    #   alf -e '(lispy command)'
    #   alf [FILE.alf]
    #   alf [alf opts] OPERATOR [operator opts] ARGS ...
    #   alf help OPERATOR
    #
    # OPTIONS
    # #{summarized_options}
    #
    # RELATIONAL COMMANDS
    # #{summarized_subcommands subcommands.select{|cmd| 
    #    cmd.include?(Alf::Operator::Relational) &&
    #    !cmd.include?(Alf::Operator::Experimental)
    # }}
    #
    # EXPERIMENTAL OPERATORS
    # #{summarized_subcommands subcommands.select{|cmd| 
    #    cmd.include?(Alf::Operator::Relational) &&
    #    cmd.include?(Alf::Operator::Experimental)
    # }}
    #
    # NON-RELATIONAL COMMANDS
    # #{summarized_subcommands subcommands.select{|cmd| 
    #    cmd.include?(Alf::Operator::NonRelational)
    # }}
    #
    # OTHER NON-RELATIONAL COMMANDS
    # #{summarized_subcommands subcommands.select{|cmd| 
    #    cmd.include?(Alf::Command)
    # }}
    #
    # See '#{program_name} help COMMAND' for details about a specific command.
    #
    class Main < Quickl::Delegator(__FILE__, __LINE__)
      include Command
    
      # Environment instance to use to get base iterators
      attr_accessor :environment
    
      # Output renderer
      attr_accessor :renderer
      
      # Creates a command instance
      def initialize(env = Environment.default)
        @environment = env
      end
      
      # Install options
      options do |opt|
        @execute = false
        opt.on("-e", "--execute", "Execute one line of script (Lispy API)") do 
          @execute = true
        end
        
        @renderer = nil
        Renderer.each_renderer do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){ 
            @renderer = clazz.new 
          }
        end
        
        opt.on('--env=ENV', 
               "Set the environment to use") do |value|
          @environment = Environment.autodetect(value)
        end
        
        opt.on('-rlibrary', "require the library, before executing alf") do |value|
          require(value)
        end
        
        opt.on_tail('-h', "--help", "Show help") do
          raise Quickl::Help
        end
        
        opt.on_tail('-v', "--version", "Show version") do
          raise Quickl::Exit, "alf #{Alf::VERSION}"\
                              " (c) 2011, Bernard Lambeau"
        end
      end # Alf's options

      #
      # Executes the command on an array of arguments.
      #
      def execute(argv)
        # 1) special case where a .alf file is provided
        if argv.empty? or (argv.size == 1 && File.exists?(argv.first))
          argv.unshift("exec")
        end

        # 2) build the operator according to -e option
        operator = if @execute
          Alf.lispy(environment).compile(argv.first)
        else
          super
        end
        
        # 3) if there is a requester, then we do the job (assuming bin/alf)
        # with the renderer to use. Otherwise, we simply return built operator
        if operator && requester
          renderer = self.renderer ||= Renderer::Rash.new
          renderer.pipe(operator, environment).execute($stdout)
        else
          operator
        end
      end
      
    end # class Main
  end # module Command
end # module Alf
