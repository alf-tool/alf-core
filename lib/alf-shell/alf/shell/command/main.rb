module Alf
  module Shell
    class Main < Shell::Delegator()
    
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
        operator = Iterator.coerce(operator, environment) if operator

        # 3) if there is a requester, then we do the job (assuming bin/alf)
        # with the renderer to use. Otherwise, we simply return built operator
        if operator && requester
          renderer_class = (self.renderer_class ||= Renderer::Rash)
          renderer = renderer_class.new(operator, rendering_options)
          renderer.execute($stdout)
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
  end # module Shell
end # module Alf
require_relative 'main/class_methods'
