def alf_required(retried)
  ["enumerator", 
   "quickl"].each{|req| require req}
rescue LoadError
  raise if retried
  require "rubygems"
  alf_required(true)
end
alf_required(false)

#
# alf - A commandline tool for relational inspired data manipulation
#
# SYNOPSIS
#   #{program_name} [--version] [--help] 
#   #{program_name} help COMMAND
#   #{program_name} COMMAND [cmd opts] ARGS ...
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
  # Show help about a specific command
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} COMMAND
  #
  class Help < Quickl::Command(__FILE__, __LINE__)
    
    # Let NoSuchCommandError be passed to higher stage
    no_react_to Quickl::NoSuchCommand
    
    # Command execution
    def execute(args)
      if args.size != 1
        puts super_command.help
      else
        cmd = has_command!(args.first, super_command)
        puts cmd.help
      end
    end
    
  end # class Help

  #
  # Included by all elements of a tuple chain
  #
  module Pipeable

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

  end # module Pipeable

  #
  # Marker for chain elements converting input streams to enumerable 
  # of tuples.
  #
  module TupleReader
    include Pipeable
    include Enumerable

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
  # Marker for chain elements converting tuple streams
  #
  module TupleWriter
    include Pipeable

    #
    # Executes the writing, outputting the resulting relation. 
    #
    # This method must be implemented by subclasses.
    #
    def execute(output = $stdout)
    end

  end # module TupleWriter

  #
  # Implements the TupleWriter contract through inspect
  #
  class HashWriter 
    include TupleWriter

    # @see TupleWriter#execute
    def execute(output = $stdout)
      @input.each do |tuple|
        output << tuple.inspect << "\n"
      end
    end

  end # class HashWriter

  #
  # Provides a handle to implement a (TODO) fly design pattern
  # on tuples.
  #
  class TupleHandle

    # Creates an handle instance
    def initialize
      @tuple = nil
    end

    #
    # Sets the next tuple to use.
    #
    # This method installs the handle as a side effect 
    # on first call. 
    #
    def set(tuple)
      build(tuple) if @tuple.nil?
      @tuple = tuple
      self
    end

    # 
    # Compiles a tuple expression and returns a lambda
    # instance that can be passed to evaluate later.
    # 
    def compile(expr)
      # TODO: refactor this to avoid relying on Kernel.eval
      Kernel.eval "lambda{ #{expr} }"
    end

    #
    # Evaluates an expression on the current tuple. Expression
    # can be a lambda or a string (immediately compiled in the
    # later case).
    # 
    def evaluate(expr)
      expr = compile(expr) unless expr.is_a?(Proc)
      if RUBY_VERSION < "1.9"
        instance_eval &expr
      else
        instance_exec &expr
      end
    end

    private

    #
    # Builds this handle with a tuple.
    #
    # This method should be called only once and installs 
    # instance methods on the handle with keys of _tuple_.
    #
    def build(tuple)
      # TODO: refactor me to avoid instance_eval
      tuple.keys.each do |k|
        self.instance_eval <<-EOF
          def #{k}; @tuple[#{k.inspect}]; end
        EOF
      end
    end

  end # class TupleHandle

  #
  # Marker for all operators on relations.
  # 
  module BaseOperator
    include Pipeable
    include Enumerable

    # 
    # Executes this operator as a commandline
    #
    def execute(args)
      set_args(args)
      [ HashReader.new, self, HashWriter.new ].inject($stdin) do |chain,n|
        n.pipe(chain)
      end.execute($stdout)
    end

    #
    # Configures the operator from arguments taken from
    # command line. This method returns the operator itself.
    #
    def set_args(args)
    end

  end # module Operator

  #
  # Specialization of BaseOperator for operators that
  # simply convert single tuples to single tuples.
  #
  module TupleTransformOperator
    include BaseOperator

    # @see BaseOperator#each
    def each
      @input.each do |tuple|
        yield tuple2tuple(tuple)
      end
    end

    protected 

    #
    # Transforms an input tuple to an output tuple
    #
    def tuple2tuple(tuple)
    end
    undef_method :tuple2tuple

  end # module TupleTransformOperator

  # 
  # Normalizes the input tuple stream by forcing default values
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 VAL1 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator rewrites tuples so as to ensure that all specified 
  # attributes ATTR are defined and not nil. Missing or nil attributes
  # are replaced by the associated default value. 
  #
  class Defaults < Quickl::Command(__FILE__, __LINE__)
    include TupleTransformOperator

    # Hash of source -> target attribute renamings
    attr_accessor :defaults

    # Builds a Defaults operator instance
    def initialize
      @defaults = {}
      yield self if block_given?
    end

    # @see BaseOperator#set_args
    def set_args(args)
      args.each_with_index{|a,i| args[i] = a.to_sym if i % 2 == 0}
      @defaults = Hash[*args]
      self
    end

    # @see TupleTransformOperator#tuple2tuple
    def tuple2tuple(tuple)
      norm = Hash[*tuple.collect{|k,v| [k, v.nil? ? @defaults[k] : v]}.flatten]
      @defaults.merge(norm)
    end

  end # class Defaults

  # 
  # Extend input tuples with attributes whose value is computed
  # with tuple expressions.
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 EXPR1 ATTR2 EXPR2...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This command extend input tuples with new attributes names ATTR1 
  # ATTR2, and so on. Values of those attributes are the result of
  # evaluating EXPR1, EXPR2, etc on input tuples.
  #
  class Extend < Quickl::Command(__FILE__, __LINE__)
    include TupleTransformOperator

    # Extensions as a Hash attr => lambda{...}
    attr_accessor :extensions

    # Builds an Extend operator instance
    def initialize
      @extensions = {}
      @handle = TupleHandle.new
      yield self if block_given?
    end

    # @see BaseOperator#set_args
    def set_args(args)
      @extensions = Hash[*args.each_slice(2).collect{|k,v|
        [k.to_sym, @handle.compile(v)]
      }.flatten]
      self
    end

    # @see TupleTransformOperator#tuple2tuple
    def tuple2tuple(tuple)
      tuple.merge Hash[*@extensions.collect{|k,v|
        [k, @handle.set(tuple).evaluate(v)]
      }.flatten]
    end

  end # class Extend

  # 
  # Project input tuples on some attributes only
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator projects tuples on attributes whose names are specified 
  # as arguments. Note that, so far, this operator does NOT remove 
  # duplicate tuples in the result and is therefore not equivalent to a
  # true relational projection.
  #
  class Project < Quickl::Command(__FILE__, __LINE__)
    include TupleTransformOperator

    # Array of projection attributes
    attr_accessor :attributes

    # Is it a --allbut projection?
    attr_accessor :allbut

    # Builds a Project operator instance
    def initialize
      @attributes = []
      @allbut = false
      yield self if block_given?
    end

    # Installs the options
    options do |opt|
      opt.on('-a', '--allbut', 'Apply a ALLBUT projection') do
        @allbut = true
      end
    end

    # @see BaseOperator#set_args
    def set_args(args)
      @attributes = args.collect{|a| a.to_sym}
      self
    end

    # @see TupleTransformOperator#tuple2tuple
    def tuple2tuple(tuple)
      @allbut ? 
        tuple.delete_if{|k,v| attributes.include?(k)} :
        tuple.delete_if{|k,v| !attributes.include?(k)}
    end

  end # class Project

  # 
  # Rename some tuple attributes
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} OLD1 NEW1 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This command renames OLD attributes as NEW as specified by 
  # arguments. Attributes OLD should exist in the source relation 
  # while attributes NEW should not.
  #
  # Example:
  #   {:id => 1} -> alf rename id identifier -> {:identifier => 1}
  #   {:a => 1, :b => 2} -> alf rename a A b B -> {:A => 1, :B => 2}
  #
  class Rename < Quickl::Command(__FILE__, __LINE__)
    include TupleTransformOperator

    # Hash of source -> target attribute renamings
    attr_accessor :renaming

    # Builds a Rename operator instance
    def initialize
      @renaming = {}
      yield self if block_given?
    end

    # @see BaseOperator#set_args
    def set_args(args)
      @renaming = Hash[*args.collect{|c| c.to_sym}]
      self
    end

    # @see TupleTransformOperator#tuple2tuple
    def tuple2tuple(tuple)
      Hash[*tuple.collect{|k,v| [@renaming[k] || k, v]}.flatten]
    end

  end # class Rename

  # 
  # Restrict input tuples to those for which an expression is true
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} EXPR
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This command restricts tuples to those for which EXPR evaluates
  # to true.
  #
  class Restrict < Quickl::Command(__FILE__, __LINE__)
    include BaseOperator

    # Hash of source -> target attribute renamings
    attr_accessor :functor

    # Builds a Rename operator instance
    def initialize
      @handle = TupleHandle.new
      @functor = @handle.compile("true")
      yield self if block_given?
    end

    def self.functor(arg)
      case arg
        when String
          TupleHandle.new.compile(arg)
        when NilClass
          TupleHandle.new.compile("true")
        when Array
          code = arg.empty? ?
            "true" :
            arg.each_slice(2).collect{|pair| "(" + pair.join("==") + ")"}.join(" and ")
          TupleHandle.new.compile(code)
        when Proc
          arg
      end
    end

    # @see BaseOperator#set_args
    def set_args(args)
      @functor = self.class.functor(args.size > 1 ? args : args.first)
      self
    end

    # @see BaseOperator#each
    def each
      @input.each{|t| yield(t) if @handle.set(t).evaluate(@functor) }
    end

  end # class Restrict

  # 
  # Nest some attributes as a new TUPLE-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ... NEWNAME
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator nests attributes ATTR1 to ATTRN as a new, tuple-based
  # attribute whose name is NEWNAME
  #
  class Nest < Quickl::Command(__FILE__, __LINE__)
    include TupleTransformOperator

    # Array of nesting attributes
    attr_accessor :attributes

    # New name for the nested attribute
    attr_accessor :as

    # Builds a Rename operator instance
    def initialize
      @attributes = []
      @as = :nested
      yield self if block_given?
    end

    # @see BaseOperator#set_args
    def set_args(args)
      @as = args.pop.to_sym
      @attributes = args.collect{|a| a.to_sym}
      self
    end

    # @see TupleTransformOperator#tuple2tuple
    def tuple2tuple(tuple)
      others = Hash[*(tuple.keys - @attributes).collect{|k| [k,tuple[k]]}.flatten]
      others[as] = Hash[attributes.collect{|k| [k, tuple[k]]}]
      others
    end

  end # class Nest

  # 
  # Unnest a TUPLE-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator unnests a tuple-valued attribute ATTR so as to 
  # flatten it pairs with 'upstream' tuple.
  #
  class Unnest < Quickl::Command(__FILE__, __LINE__)
    include TupleTransformOperator

    # Name of the attribute to unnest
    attr_accessor :attribute

    # Builds a Rename operator instance
    def initialize
      @attribute = "nested"
      yield self if block_given?
    end

    # @see BaseOperator#set_args
    def set_args(args)
      @attribute = args.last.to_sym
      self
    end

    # @see TupleTransformOperator#tuple2tuple
    def tuple2tuple(tuple)
      tuple = tuple.dup
      nested = tuple.delete(@attribute) || {}
      tuple.merge(nested)
    end

  end # class Unnest

  # 
  # Group some attributes as a new RELATION-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ... NEWNAME
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator groups attributes ATTR1 to ATTRN as a new, relation-values
  # attribute whose name is NEWNAME
  #
  class Group < Quickl::Command(__FILE__, __LINE__)
    include BaseOperator

    # Attributes on which grouping applies
    attr_accessor :attributes
  
    # Attribute name for grouping tuple 
    attr_accessor :as

    # Creates a Group instance
    def initialize
      @attributes = @as = nil
      yield self if block_given?
    end

    # @see BaseOperator#set_args
    def set_args(args)
      @as = args.pop.to_sym
      @attributes = args.collect{|a| a.to_sym}
      self
    end

    # See BaseOperator#each
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

    protected

    def split_tuple(tuple)
      key, rest = tuple.dup, {}
      @attributes.each do |a|
        rest[a] = tuple[a]
        key.delete(a)
      end
      [key,rest]
    end

  end # class Group

  # 
  # Ungroup a RELATION-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator ungroup the relation-valued attribute whose
  # name is ATTR
  #
  class Ungroup < Quickl::Command(__FILE__, __LINE__)
    include BaseOperator

    # Relation-value attribute to ungroup
    attr_accessor :attribute
  
    # Creates a Group instance
    def initialize
      @attribute = :grouped
      yield self if block_given?
    end

    # @see BaseOperator#set_args
    def set_args(args)
      @attribute = args.pop.to_sym
      self
    end

    # See BaseOperator#each
    def each
      @input.each do |tuple|
        tuple = tuple.dup
        subrel = tuple.delete(@attribute)
        subrel.each do |subtuple|
          yield(tuple.merge(subtuple))
        end
      end
    end

  end # class Ungroup

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
      opt.on("--yaml") do 
        @output = :yaml
      end
    end

    def output(res)
      case @output
        when :text
          Renderer::Text.render(res.to_a, $stdout)
        when :yaml
          require 'yaml'
          $stdout << res.to_a.to_yaml
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

  # 
  # Implements a small LISP-like DSL on top of Alf
  #
  module Lispy

    # Factors a DEFAULTS operator
    def defaults(child, defaults)
      pipe(Defaults.new{|d| d.defaults = defaults}, child)
    end

    # Factors an EXTEND operator
    def extend(child, extensions)
      pipe(Extend.new{|op| op.extensions = extensions}, child)
    end

    # Factors a PROJECT operator
    def project(child, *attrs)
      pipe(Project.new{|p| p.attributes = attrs.flatten}, child)
    end

    # Factors a PROJECT-ALLBUT operator
    def allbut(child, *attrs)
      pipe(Project.new{|p| p.attributes = attrs.flatten; p.allbut = true}, child)
    end

    # Factors a RENAME operator
    def rename(child, renaming)
      pipe(Rename.new{|r| r.renaming = renaming}, child)
    end

    # Factors a RESTRICT operator
    def restrict(child, functor)
      pipe(Restrict.new{|r| r.functor = Restrict.functor(functor)}, child)
    end

    # Factors a NEST operator
    def nest(child, nesting)
      pipe(Nest.new{|r| r.attributes = nesting[nesting.keys.first]
                        r.as = nesting.keys.first}, child)
    end

    private

    def pipe(parent, child)
      child = case child
        when IO
          HashReader.new(child)
        when Array, Pipeable
          child
        else
          raise ArgumentError, "Unable to pipe with #{child}"
      end
      parent.pipe(child)
    end

    extend Lispy
  end # module Lispy

end # class Alf
require "alf/renderer/text"
require "alf/renderer/plot"
