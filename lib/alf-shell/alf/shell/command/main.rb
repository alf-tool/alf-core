module Alf
  module Shell
    class Main < Shell::Delegator()

      class << self

        def relational_operators(sort_by_name = true)
          ops = subcommands.select{|cmd|
             cmd.operator? and cmd.relational? and !cmd.experimental?
          }
          sort_operators(ops, sort_by_name)
        end

        def experimental_operators(sort_by_name = true)
          ops = subcommands.select{|cmd|
            cmd.operator? and cmd.relational? and cmd.experimental?
          }
          sort_operators(ops, sort_by_name)
        end

        def non_relational_operators(sort_by_name = true)
          ops = subcommands.select{|cmd|
            cmd.operator? and !cmd.relational?
          }
          sort_operators(ops, sort_by_name)
        end

        def other_non_relational_commands(sort_by_name = true)
          ops = subcommands.select{|cmd|
            cmd.command?
          }
          sort_operators(ops, sort_by_name)
        end

        private

        def sort_operators(ops, sort_by_name)
          sort_by_name ? ops.sort{|op1,op2|
            op1.command_name.to_s <=> op2.command_name.to_s
          } : ops
        end

      end # class << self

      # Connection instance to use to get base relations
      attr_accessor :database

      # The reader to use when stdin is used as operand
      attr_accessor :stdin_operand

      # Output renderer
      attr_accessor :renderer_class

      # Rendering options
      attr_reader :rendering_options

      # Creates a command instance
      def initialize(db = Alf.connect(Path.pwd))
        @database = db
        @rendering_options = {}
      end

      # Install options
      options do |opt|
        @execute = false
        opt.on("-e", "--execute", "Execute one line of script (Lispy API)") do
          @execute = true
        end

        @renderer_class = nil
        Renderer.each do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){
            @renderer_class = clazz
          }
        end

        opt.on('--examples', "Use the example database for database") do
          @database = Alf.examples
        end

        opt.on('--db=DB',
               "Set the database to use") do |value|
          @database = Alf.connect(value)
        end

        @input_reader = :rash
        readers = Reader.all.map{|r| r.first}
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

      def stdin_operand
        @stdin_operand || Reader.send(@input_reader, $stdin)
      end

      def execute(argv)
        # special case where a .alf file is provided
        if argv.empty? or (argv.size == 1 && Path(argv.first).exist?)
          argv.unshift("exec")
        end

        # compile the operator, render and returns it
        compile(argv){ super }.tap do |op|
          render(op) if op && requester
        end
      end

      def pretty=(val)
        @rendering_options[:pretty] = val
        if val && (hl = highline)
          @rendering_options[:trim_at] = hl.output_cols
          @rendering_options[:page_at] = hl.output_rows
        end
        val
      end

    private

      def compile(argv)
        if @execute
          database.query(argv.first)
        else
          op = yield
          database.cog(op) if op
        end
      end

      def render(operator, out = $stdout)
        renderer_class = self.renderer_class || default_renderer_class
        renderer = renderer_class.new(operator, rendering_options)
        renderer.execute(out)
      end

      def highline
        require 'highline'
        HighLine.new($stdin, $stdout)
      rescue LoadError => ex
        nil
      end

      def default_renderer_class
        $stdout.tty? ? Text::Renderer : Renderer::Rash
      end

    end # class Main
  end # module Shell
end # module Alf
