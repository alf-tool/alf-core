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

  # Handles Alf's version 
  module Version
    MAJOR = 1
    MINOR = 0
    TINY  = 0
    def self.to_s
      [ MAJOR, MINOR, TINY ].join('.')
    end
  end 
  VERSION = Version.to_s

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
  # Marker for chain elements converting input streams
  # to enumerable of tuples.
  #
  module TupleReader
    include Enumerable

    # Input stream
    attr_reader :input

    #
    # Pipes with an input stream, typically a IO object
    #
    # This method simply sets _input_ under a variable instance of
    # same name and returns self.
    #
    def pipe(input)
      @input = input
      self
    end

    #
    # Yields the block with each tuple (converted from the
    # input stream) in turn.
    #
    # Default implementation reads lines of the input stream and
    # yields the block with <code>line2tuple(line)</code> on each
    # of them
    #
    def each
      input.each_line do |line| 
        tuple = line2tuple(line)
        yield tuple unless tuple.nil?
      end
    end

    protected

    #
    # Converts a line previously read from the input stream
    # to a tuple.
    #
    # This method MUST be implemented by subclasses.
    #
    def line2tuple(line)
    end
    undef_method :line2tuple

  end # module TupleReader

  #
  # Implements the TupleReader contract for a stream where each line is 
  # a ruby hash literal, as a tuple physical representation.
  #
  class HashReader
    include TupleReader

    # @see TupleReader#line2tuple
    def line2tuple(line)
      begin
        h = Kernel.eval(line)
        raise "hash expected, got #{h}" unless h.is_a?(Hash)
      rescue Exception => ex
        $stderr << "Skipping #{line.strip}: #{ex.message}\n"
        nil
      else
        return h
      end
    end

  end # class HashReader

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
  # Rename attributes
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # OPTIONS
  # #{summarized_options}
  #
  class Renamer < Quickl::Command(__FILE__, __LINE__)
    include Pipeable

    attr_accessor :renaming

    def initialize
      @renaming = {}
      yield self if block_given?
    end

    # Install options
    options do |opt|
      opt.on('-r x,y', Array,
             "Specify a renaming") do |value|
        @renaming[value.first.to_sym] = value.last.to_sym
      end
    end

    def each
      @input.each do |tuple|
        renamed = {}
        tuple.each_pair do |k,v|
          renamed[@renaming[k] || k] = v
        end
        yield(renamed)
      end
    end

  end # class Renamer

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
  # Groups and renamed everything to be plottable
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # OPTIONS
  # #{summarized_options}
  #
  class Plotter < Quickl::Command(__FILE__, __LINE__)
    include Pipeable

    attr_accessor :title
    attr_accessor :abscissa
    attr_accessor :ordinate
    attr_accessor :series

    def initialize
      yield self if block_given?
    end

    # Install options
    options do |opt|
      opt.on('-t title', "Specify graph title") do |value|
        self.title = value.to_sym
      end
      opt.on('-x abscissa', "Specify abscissa attribute") do |value|
        self.abscissa = value.to_sym
      end
      opt.on('-y ordinate', "Specify ordinate attribute") do |value|
        self.ordinate = value.to_sym
      end
      opt.on('-s series', "Specify series attribute") do |value|
        self.series = value.to_sym
      end
    end

    def build
      renamer = Renamer.new{|r| r.renaming = {abscissa => :x, ordinate => :y, series => :title}}
      grouper = Grouper.new{|g| g.attributes = [:x, :y]; g.as = :data}
      datasetter = Grouper.new{|g| g.attributes = [:title, :data]; g.as = :datasets}
      titler = Renamer.new{|r| r.renaming = {title => :title}}
      titler.pipe(datasetter.pipe(grouper.pipe(renamer.pipe(@input))))
    end

    def each
      build.each(&Proc.new)
    end

  end # class Plotter

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
      @output = :hash
      opt.on("--text") do 
        @output = :text
      end
      opt.on("--plot") do 
        @output = :plot
      end
    end

    def output(res)
      case @output
        when :text
          Renderer::Text.render(res.to_a, $stdout)
        when :plot
          Renderer::Plot.render(res.to_a, $stdout)
        when :hash
          res.each{|t| $stdout << t.inspect << "\n"}
      end
    end

    def execute(args)
      output HashReader.new.pipe($stdin)
    end

  end # class Render

end # class Alf
require "alf/renderer/text"
require "alf/renderer/plot"
