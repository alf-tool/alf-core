require 'alf/loader'
#
# alf - A commandline tool for relational inspired data manipulation
#
# SYNOPSIS
#   #{program_name} [--version] [--help] COMMAND [cmd opts] ARGS...
#
# OPTIONS
# #{summarized_options}
#
# COMMANDS
# #{summarized_subcommands}
#
# See '#{program_name} help COMMAND' for more information on a specific command.
#
class Alf < Quickl::Delegator(__FILE__, __LINE__)

  # Load the version now
  require 'alf/version'

  # Install options
  options do |opt|
    opt.on_tail("--help", "Show help") do
      raise Quickl::Help
    end
    opt.on_tail("--version", "Show version") do
      raise Quickl::Exit, "#{program_name} #{Alf::VERSION} (c) 2011, Bernard Lambeau"
    end
  end # Alf's options

  #
  # Common module for all pipeable nodes
  #
  module Pipeable
    include Enumerable

    def pipe(input)
      @input = input
      self
    end

    def output(res)
      res.each{|t| $stdout << t.inspect << "\n"}
    end

    def execute(args)
      output pipe(HashReader.new.pipe($stdin))
    end

  end # module Pipeable

  #
  # Reads the input pipe and convert each line to a ruby Hash
  #
  class HashReader
    include Pipeable

    def each
      @input.each_line do |line|
        begin
          h = Kernel.eval(line)
          raise "hash expected, got #{h}" unless h.is_a?(Hash)
        rescue Exception => ex
          $stderr << "Skipping #{line.strip}: #{ex.message}\n"
        else
          yield(h)
        end
      end
    end

  end # class HashReader

  # 
  # Group some attributes as a RVA
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # OPTIONS
  # #{summarized_options}
  #
  class Grouper < Quickl::Command(__FILE__, __LINE__)
    include Pipeable

    attr_accessor :attributes
    attr_accessor :as

    def initialize
      @attributes = @as = @input = nil
      yield self if block_given?
    end

    # Install options
    options do |opt|
      opt.on('--attributes x,y,z', Array,
             "Specify grouping attributes") do |value|
        self.attributes = value.collect{|c| c.to_sym}
      end
      opt.on('--as x', 
             "Specify new group attribute name") do |value|
        self.as = value.to_s.to_sym
      end
    end

    def each
      index = Hash.new{|h,k| h[k] = []} 
      @input.each do |tuple|
        key, rest = split_tuple(tuple)
        index[key] << rest
      end
      index.each_pair do |k,v|
        yield(k.merge(@as => v))
      end
    end

    def split_tuple(tuple)
      key, rest = tuple.dup, {}
      @attributes.each do |a|
        rest[a] = tuple[a]
        key.delete(a)
      end
      [key,rest]
    end

  end # class Grouper

  # 
  # Renders its input according to a renderer
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # OPTIONS
  # #{summarized_options}
  #
  class Render < Quickl::Command(__FILE__, __LINE__)

    options do |opt|
      @text_output = false
      opt.on("--text") do 
        @text_output = true
      end
    end

    def output(res)
      if @text_output
        Renderer::Text.render(res.to_a, $stdout)
      else
        res.each{|t| $stdout << t.inspect << "\n"}
      end
    end

    def execute(args)
      output HashReader.new.pipe($stdin)
    end

  end # class Render

end # class Alf
require "alf/renderer/text"
