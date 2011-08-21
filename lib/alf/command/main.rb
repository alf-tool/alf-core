module Alf
  module Command
    class Main < Alf::Delegator()
      include Command
    
      module ClassMethods

        def relational_operators(sort_by_name = false)
          ops = subcommands.select{|cmd| 
             cmd.include?(Alf::Operator::Relational) &&
            !cmd.include?(Alf::Operator::Experimental)
          }
          sort_operators(ops, sort_by_name)
        end

        def experimental_operators(sort_by_name = false)
          ops = subcommands.select{|cmd| 
            cmd.include?(Alf::Operator::Relational) &&
            cmd.include?(Alf::Operator::Experimental)
          }
          sort_operators(ops, sort_by_name)
        end

        def non_relational_operators(sort_by_name = false)
          ops = subcommands.select{|cmd| 
            cmd.include?(Alf::Operator::NonRelational)
          }
          sort_operators(ops, sort_by_name)
        end

        def other_non_relational_commands(sort_by_name = false)
          ops = subcommands.select{|cmd| 
            cmd.include?(Alf::Command)
          }
          sort_operators(ops, sort_by_name)
        end

        private

        def sort_operators(ops, sort_by_name)
          sort_by_name ? ops.sort{|op1,op2| 
            op1.command_name.to_s <=> op2.command_name.to_s
          } : ops
        end

      end
      extend(ClassMethods)

      # Environment instance to use to get base iterators
      attr_accessor :environment

      # The reader to use when stdin is used as operand
      attr_accessor :stdin_reader

      # Output renderer
      attr_accessor :renderer_class

      # Rendering options
      attr_reader :rendering_options

      # Creates a command instance
      def initialize(env = Environment.default)
        @environment = env
        @rendering_options = {}
      end
      
      # Install options
      options do |opt|
        @execute = false
        opt.on("-e", "--execute", "Execute one line of script (Lispy API)") do 
          @execute = true
        end
        
        @renderer_class = nil
        Renderer.each_renderer do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){ 
            @renderer_class = clazz
          }
        end
        
        opt.on('--env=ENV', 
               "Set the environment to use") do |value|
          @environment = Environment.autodetect(value)
        end

        @input_reader = :rash
        readers = Reader.readers.collect{|r| r.first}
        opt.on('--input-reader=READER', readers,
               "Specify the kind of reader when reading on $stdin "\
               "(#{readers.join(',')})") do |value|
          @input_reader = value.to_sym
        end
        
        opt.on("-Idirectory", 
               "Specify $LOAD_PATH directory (may be used more than once)") do |val|
          $LOAD_PATH.unshift val
        end

        opt.on('-rlibrary', 
               "Require the library, before executing alf") do |value|
          require(value)
        end
        
        opt.on("--[no-]pretty", 
               "Enable/disable pretty print best effort") do |val|
          self.pretty = val
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
      # Returns the $stdin Reader to use, according to the 
      # --input-reader= option
      #
      def stdin_reader
        @stdin_reader || Reader.send(@input_reader, $stdin)
      end

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
          renderer_class = self.renderer_class ||= Renderer::Rash
          renderer = renderer_class.new(rendering_options)
          renderer.pipe(operator, environment).execute($stdout)
        else
          operator
        end
      end

      #
      # Returns rendering options
      #
      def pretty=(val)
        @rendering_options[:pretty] = val
        if val && (hl = highline)
          @rendering_options[:trim_at] = hl.output_cols
          @rendering_options[:page_at] = hl.output_rows
        end
        val
      end

      #
      # Returns a highline instance
      # 
      def highline
        require 'highline'
        HighLine.new($stdin, $stdout)
      rescue LoadError => ex
        nil
      end
      
    end # class Main
  end # module Command
end # module Alf
