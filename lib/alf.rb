def alf_required(retried)
  ["enumerator", 
   "stringio", 
   "quickl"].each{|req| require req}
rescue LoadError
  raise if retried
  require "rubygems"
  alf_required(true)
end
alf_required(false)

#
# alf - Classy data-manipulation dressed in a DSL (+ commandline)
#
# SYNOPSIS
#   #{program_name} [--version] [--help] 
#   #{program_name} [FILE.alf]
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
  
  # Alf's version 
  VERSION = "0.9.0"

  ############################################################################# TOOLS
  #
  # The following modules and classes provide tools for implementing dataflow
  # elements.
  #

  # Provides tooling 
  module Tools
    
    def class_name(clazz)
      clazz.name.to_s =~ /([A-Za-z0-9_]+)$/
      $1.to_sym
    end
    
    def ruby_case(s)
      s.to_s.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1]
    end
    
    extend Tools
  end # module Tools
  
  #
  # Provides a handle, implementing a flyweight design pattern on tuples.
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
    def self.compile(expr)
      case expr
      when Proc
        expr
      when NilClass
        compile('true')
      when Hash
        if expr.empty?
          compile(nil)
        else
          # TODO: replace inspect by to_ruby
          compile expr.each_pair.collect{|k,v| 
            "(#{k} == #{v.inspect})"
          }.join(" && ")
        end
      when Array
        compile(Hash[*expr])
      when String, Symbol
        eval("lambda{ #{expr} }")
      else
        raise ArgumentError, "Unable to compile #{expr} to a TupleHandle"
      end
    end

    #
    # Evaluates an expression on the current tuple. Expression
    # can be a lambda or a string (immediately compiled in the
    # later case).
    # 
    def evaluate(expr)
      if RUBY_VERSION < "1.9"
        instance_eval(&TupleHandle.compile(expr))
      else
        instance_exec(&TupleHandle.compile(expr))
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
      tuple.keys.each do |k|
        (class << self; self; end).send(:define_method, k) do
          @tuple[k]
        end
      end
    end

  end # class TupleHandle

  #
  # Provides tools for manipulating tuples
  #
  module TupleTools

    #
    # Returns the first non nil values from arguments
    #
    def coalesce(*args)
      args.find{|x| !x.nil?}
    end
    
    #
    # Iterates over enum and yields the block on each element. 
    # Collect block results as key/value pairs returns them as 
    # a Hash.
    #
    def tuple_collect(enum)
      tuple = {}
      enum.each do |elm| 
        k, v = yield(elm)
        tuple[k] = v
      end
      tuple
    end

  end # module TupleTools

  # 
  # Defines a projection key
  # 
  class ProjectionKey
    include TupleTools

    # Projection attributes
    attr_accessor :attributes

    # Allbut projection?
    attr_accessor :allbut

    def initialize(attributes, allbut = false)
      @attributes = attributes
      @allbut = allbut
    end

    def self.coerce(arg)
      case arg
        when Array
          ProjectionKey.new(arg, false)
        when OrderingKey
          ProjectionKey.new(arg.attributes, false)
        when ProjectionKey
          arg
        else
          raise ArgumentError, "Unable to coerce #{arg} to a projection key"
      end
    end

    def to_ordering_key
      OrderingKey.new attributes.collect{|arg|
        [arg, :asc]
      }
    end

    def project(tuple)
      split(tuple).first
    end

    def split(tuple)
      projection, rest = {}, tuple.dup
      attributes.each do |a|
        projection[a] = tuple[a]
        rest.delete(a)
      end
      @allbut ? [rest, projection] : [projection, rest]
    end

  end # class ProjectionKey

  #
  # Encapsulates tools for computing orders on tuples
  #
  class OrderingKey

    attr_reader :ordering

    def initialize(ordering = [])
      @ordering = ordering
      @sorter = nil
    end

    def self.coerce(arg)
      case arg
        when Array
          if arg.all?{|a| a.is_a?(Symbol)}
            arg = arg.collect{|a| [a, :asc]}
          end
          OrderingKey.new(arg)
        when ProjectionKey
          arg.to_ordering_key
        when OrderingKey
          arg
        else
          raise ArgumentError, "Unable to coerce #{arg} to an ordering key"
      end
    end

    def attributes
      @ordering.collect{|arg| arg.first}
    end

    def order_by(attr, order = :asc)
      @ordering << [attr, order]
      @sorter = nil
      self
    end

    def order_of(attr)
      @ordering.find{|arg| arg.first == attr}.last
    end

    def compare(t1,t2)
      @ordering.each do |attr,order|
        comp = (t1[attr] <=> t2[attr])
        comp *= -1 if order == :desc
        return comp unless comp == 0
      end
      return 0
    end

    def sorter
      @sorter ||= lambda{|t1,t2| compare(t1, t2)}
    end

    def +(other)
      other = OrderingKey.coerce(other)
      OrderingKey.new(@ordering + other.ordering)
    end

  end # class OrderingKey

  ############################################################################# PUBLIC API
  #
  # Alf's public APIs are defined below. 
  #

  #
  # Provides a factory over Alf operators and handles the interface with
  # Quickl for commandline support.
  # 
  module Factory

    # @see Quickl::Command
    def Command(file, line)
      res = Quickl::Command(file, line)
      Quickl.command_builder{|b| yield(b)} if block_given?
      res
    end

    # @see Operator
    def Operator(file, line)
      Command(file, line) do |b|
        b.instance_module Alf::Operator
      end
    end

    extend Factory
  end # module Factory
  
  # 
  # Implements a small LISP-like DSL on top of Alf
  #
  module Lispy
    
    #
    # Compiles a query expression given by a String or a block and returns
    # the result (typically a tuple iterator)
    #
    def compile(expr, &block)
      instance_eval(expr, &block)
    end
    
    #
    # Coerces _arg_ to a reader
    #
    def reader(arg, env = _the_env)
      Reader.coerce(arg, env)
    end
    
    # 
    # Coerces _arg_ to a tuple iterator
    #
    def iterator(arg, env = _the_env)
      Iterator.coerce(arg, env)
    end
    
    #
    # Chains some elements as a new operator
    #
    def chain(*elements)
      elements = elements.reverse
      elements[1..-1].inject(elements.first) do |c, elm|
        elm.pipe(c, _the_env)
        elm
      end
    end
    
    [:Defaults,
     :NoDuplicates,
     :Sort,
     :Clip,
     :Project,
     :Extend, 
     :Rename,
     :Restrict,
     :Nest,
     :Unnest,
     :Group,
     :Ungroup,
     :Summarize,
     :Quota ].each do |op_name|
      meth_name = Tools.ruby_case(op_name).to_sym
      define_method(meth_name) do |child, *args|
        chain(Alf.const_get(op_name).new(*args), child)
      end
    end

    def allbut(child, attributes)
      chain(Project.new(attributes, true), child)
    end

    [ :Join ].each do |op_name|
      meth_name = Tools.ruby_case(op_name).to_sym
      define_method(meth_name) do |left, right, *args|
        chain(Alf.const_get(op_name).new(*args), [left, right])
      end
    end
    
    private

    def _the_env
      respond_to?(:environment) ? environment : nil
    end
    
    extend Lispy
  end # module Lispy

  #
  # Encapsulates the interface with the outside world, providing base iterators
  # among others.
  # 
  class Environment
    
    #
    # Specialization of Environment to work on files of a given folder
    #
    class Folder < Environment
      
      def initialize(folder)
        @folder = folder
      end
      
      def find_file(name)
        # TODO: refactor this, because it allows getting out of the folder
        if File.exists?(name.to_s)
          name.to_s
        elsif File.exists?(explicit = File.join(@folder, name.to_s)) &&
              File.file?(explicit)
          explicit
        else
          Dir[File.join(@folder, "**/#{name}.*")].find do |f|
            File.file?(f)
          end
        end
      end
      
      def dataset(name)
        if file = find_file(name)
          ext = File.extname(file)
          if clazz = Reader.reader_class_by_file_extension(ext)
            clazz.new(file, self)
          else
            raise "No reader associated to extension '#{ext}' (#{file})"
          end
        else
          raise "No such dataset #{name}"
        end
      end
      
    end # class Folder
    
    # Returns the default environment
    def self.default
      Folder.new File.expand_path('../../examples', __FILE__)
    end
    
    # Returns the examples environment
    def self.examples
      Folder.new File.expand_path('../../examples', __FILE__)
    end
    
  end # class Environment

  #
  # This is a marker module for all elements that implement tuple iterators
  # 
  module Iterator
    include Enumerable

    # 
    # Coerces something to an iterator
    #
    def self.coerce(arg, env)
      case arg
      when Iterator, Array
        arg
      else
        Reader.coerce(arg, env)
      end
    end
    
  end # module Iterator

  ############################################################################# AGGREGATORS
  #
  # Aggregators collect computation on tuples.
  #

  #
  # Base class for implementing aggregation operators.
  #
  class Aggregator

    # Aggregate options 
    attr_reader :options

    #
    # Automatically installs factory methods for inherited classes.
    #
    # Example: 
    #   class Sum < Aggregate   # will give a method Aggregator.sum
    #     ...
    #   end
    #   Aggregator.sum(:size)   # factor an Sum aggregator on tuple[:size]
    #   Aggregator.sum{ size }  # idem but works on any tuple expression
    # 
    def self.inherited(clazz)
      basename = Tools.ruby_case(Tools.class_name(clazz))
      instance_eval <<-EOF
        def #{basename}(*args, &block)
          #{clazz}.new(*args, &block)
        end
      EOF
    end

    def self.compile(expr, &block)
      instance_eval(expr, &block)
    end
    
    #
    # Creates an Aggregator instance.
    #
    # This constructor can be used either by passing an attribute
    # argument or a block that will be evaluated on a TupleHandle
    # instance set on each aggregated tuple.
    #
    #   Aggregator.new(:size) # will aggregate on tuple[:size]
    #   Aggregator.new{ size * price } # ... on tuple[:size] * tuple[:price]
    #
    def initialize(attribute = nil, options = {}, &block)
      attribute, options = nil, attribute if attribute.is_a?(Hash)
      @handle = TupleHandle.new
      @options = default_options.merge(options)
      @functor = TupleHandle.compile(attribute || block)
    end

    #
    # Returns the default options to use
    #
    def default_options
      {}
    end

    #
    # Returns the least value, which is the one to use on an empty
    # set.
    #
    # This method is intended to be overriden by subclasses; default 
    # implementation returns nil.
    # 
    def least
      nil
    end

    # 
    # This method is called on each aggregated tuple and must return
    # an updated _memo_ value. It can be seen as the block typically
    # given to Enumerable.inject.
    #
    # The default implementation collects the pre-value on the tuple 
    # and delegates to _happens.
    #
    def happens(memo, tuple)
      _happens(memo, @handle.set(tuple).evaluate(@functor))
    end

    #
    # This method finalizes a computation.
    #
    # Argument _memo_ is either _least_ or the result of aggregating 
    # through _happens_. The default implementation simply returns
    # _memo_. The method is intended to be overriden for complex 
    # aggregations that need statefull information. See Avg for an 
    # example 
    #
    def finalize(memo)
      memo
    end

    #
    # Aggregates over an enumeration of tuples. 
    #
    def aggregate(enum)
      finalize(
        enum.inject(least){|memo,tuple| 
          happens(memo, tuple)
        })
    end

    protected

    #
    # @see happens.
    #
    # This method is intended to be overriden and returns _value_
    # by default, making this aggregator a "Last" one...
    #
    def _happens(memo, value)
      value
    end

    # 
    # Defines a COUNT aggregation operator
    #
    class Count < Aggregator
      def least(); 0; end
      def happens(memo, tuple) memo + 1; end
    end # class Count

    # 
    # Defines a SUM aggregation operator
    #
    class Sum < Aggregator
      def least(); 0; end
      def _happens(memo, val) memo + val; end
    end # class Sum

    # 
    # Defines an AVG aggregation operator
    #
    class Avg < Aggregator
      def least(); [0.0, 0.0]; end
      def _happens(memo, val) [memo.first + val, memo.last + 1]; end
      def finalize(memo) memo.first / memo.last end
    end # class Sum

    # 
    # Defines a MIN aggregation operator
    #
    class Min < Aggregator
      def least(); nil; end
      def _happens(memo, val) 
        memo.nil? ? val : (memo < val ? memo : val) 
      end
    end # class Min

    # 
    # Defines a MAX aggregation operator
    #
    class Max < Aggregator
      def least(); nil; end
      def _happens(memo, val) 
        memo.nil? ? val : (memo > val ? memo : val) 
      end
    end # class Max

    #
    # Defines a COLLECT aggregation operator
    #
    class Collect < Aggregator
      def least(); []; end
      def _happens(memo, val) 
        memo << val
      end
    end

    # 
    # Defines a CONCAT aggregation operator
    # 
    class Concat < Aggregator
      def least(); ""; end
      def default_options
        {:before => "", :after => "", :between => ""}
      end
      def _happens(memo, val) 
        memo << options[:between].to_s unless memo.empty?
        memo << val.to_s
      end
      def finalize(memo)
        options[:before].to_s + memo + options[:after].to_s
      end
    end

  end # class Aggregator

  ############################################################################# BUFFERS
  #
  # Buffers allow holding tuples in memory or on disk and provided efficient
  # accesses to them.
  #

  #
  # Base class for implementing buffers.
  # 
  class Buffer

    # 
    # Keeps tuples ordered on a specific key
    #
    class Sorted < Buffer
  
      def initialize(ordering_key)
        @ordering_key = ordering_key
        @buffer = []
      end
  
      def add_all(enum)
        sorter = @ordering_key.sorter
        @buffer = merge_sort(@buffer, enum.to_a.sort(&sorter), sorter)
      end
  
      def each
        @buffer.each(&Proc.new)
      end
  
      private
    
      def merge_sort(s1, s2, sorter)
        (s1 + s2).sort(&sorter)
      end
  
    end # class Buffer::Sorted
    
  end # class Buffer

  ############################################################################# READERS
  #
  # Readers are dataflow elements at the input boundary with the outside world.
  # They typically convert IO streams as Enumerable tuple streams. All readers
  # should follow the basis given by Reader.
  #
  
  #
  # Base class for implementing tuple readers.
  #
  # The contrat of a Reader is simply to be an Enumerable of tuple. Unlike 
  # operators, however, readers are not expected to take tuple enumerators
  # as input but IO objects, database tables, or something similar instead.
  # This base class provides a default behavior for readers that works with 
  # IO objects. It can be safely extended, overriden, or mimiced.
  #
  class Reader
    include Iterator

    # Registered readers
    @@readers = []
    
    # Registers a reader associated with specific file extensions    
    def self.register(name, extensions, clazz)
      @@readers << [name, extensions, clazz]
      (class << self; self; end).send(:define_method, name) do |*args|
        clazz.new(*args)
      end
    end

    # Returns a reader instance for a given file extension
    def self.reader_class_by_file_extension(ext)
      x = @@readers.find{|r| r[1].include?(ext)}
      x ? x.last : nil
    end
        
    # Coerces an argument to a reader, using an optional environement
    # to convert named datasets
    def self.coerce(arg, environment = nil)
      case arg
      when Reader
        arg
      when IO
        rash(arg, environment)
      when String, Symbol
        if environment
          environment.dataset(arg.to_sym)
        else
          raise "No environment set"
        end
      else
        raise ArgumentError, "Unable to coerce #{arg.inspect} to a reader"
      end
    end
    
    # Environment instance
    attr_accessor :environment

    # Input IO, or file name
    attr_accessor :input

    # Creates a reader instance, with an optional input
    #
    def initialize(input = nil, environment = nil)
      @input = input
      @environment = environment 
    end

    # 
    # Sets the reader input
    #
    def pipe(input, env = environment)
      @input = input
    end
    
    #
    # Yields the block with each tuple (converted from the input stream) in 
    # turn.
    #
    # The default implementation reads lines of the input stream and yields the 
    # block with <code>_line2tuple(line)</code> on each of them. This method
    # may be overriden if this behavior does not fit reader's needs.
    #
    def each
      each_input_line do |line| 
        tuple = _line2tuple(line)
        yield tuple unless tuple.nil?
      end
    end

    protected
    
    def with_input_io
      case input
      when IO, StringIO
        yield input
      when String
        File.open(input, 'r'){|io| yield io}
      else
        raise "Unable to convert #{input} to an IO object"
      end
    end
    
    def input_text
      with_input_io{|io| io.readlines.join}
    end
    
    def each_input_line
      with_input_io{|io| io.each_line(&Proc.new)}
    end

    #
    # Converts a line previously read from the input stream to a tuple. 
    #
    # The line is simply ignored is this method return nil. Errors should be
    # properly handled by raising exceptions. This method MUST be implemented 
    # by subclasses unless each is overriden.
    #
    def _line2tuple(line)
    end

    #
    # Specialization of the Reader contract for .rash files.
    #
    # A .rash file/stream contains one ruby hash literal on each line (taken as 
    # a tuple physical representation). This reader simply decodes each of them 
    # in turn with Kernel.eval, providing a state-less reader (in the sense 
    # that tuples are not all loaded in memory). 
    #
    class Rash < Reader
  
      # @see Reader#_line2tuple
      def _line2tuple(line)
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

      Reader.register(:rash, [".rash"], self)  
    end # class Rash

    #
    # Specialization of the Reader contrat for .alf files.
    #
    # A .alf file simply contains a query expression in the Lispy DSL. This
    # reader decodes and compile the expression and delegates the enumeration
    # to the obtained operator.
    #
    class AlfFile < Reader
      
      # @see Reader#each
      def each
        op = Alf.new(environment).compile(input_text)
        op.each(&Proc.new)
      end
      
      Reader.register(:alf, [".alf"], self)
    end # class AlfFile

    require "alf/reader/yaml"
  end # module Reader

  ############################################################################# RENDERERS
  #
  # Renderers are dataflow elements at the output boundary with the outside 
  # world. They typically output Enumerable tuple streams on IO streams. 
  # All renderers should follow the basis given by Renderer.
  #
  
  #
  # Base class for implementing renderers.
  #
  # A renderer takes a tuple iterator as input and renders it on an output
  # stream. Unlike operators, renderers are not tuple enumerators anymore
  # and are typically used as chain end elements. 
  #
  class Renderer

    # Keeps the renderers
    @@renderers = []
    
    # Automatically installs rendering methods on the class itself
    def self.register(name, description, clazz)
      @@renderers << [name, description, clazz]
      (class << self; self; end).
        send(:define_method, name) do |input, *args|
          clazz.new(input).execute(*args)
        end
    end

    # Returns the names of registered renderers
    def self.renderer_names
      @@renderers.collect{|x| x.first}
    end
    
    # Returns a renderer class by its name
    def self.renderer_by_name(name)
      @@renderers.find{|x| x.first.to_s == name.to_s}.last
    end
    
    # Yields each (name,clazz) registered renderer pairs in turn
    def self.each_renderer
      @@renderers.each(&Proc.new)
    end
    
    # Writer input
    attr_accessor :input
    
    #
    # Creates a renderer instance with an optional input
    #
    def initialize(input = nil)
      @input = input
    end
    
    # 
    # Sets the renderer input
    #
    def pipe(input, env = environment)
      @input = Iterator.coerce(input, env)
    end

    #
    # Executes the rendering, outputting the resulting tuples. 
    #
    # This method must be implemented by subclasses and must return the output
    # buffer itself. 
    #
    def execute(output = $stdout)
      output
    end

    #
    # Implements the Renderer contract through inspect
    #
    class Rash < Renderer
  
      # @see Renderer#execute
      def execute(output = $stdout)
        input.each do |tuple|
          output << tuple.inspect << "\n"
        end
        output
      end
  
      Renderer.register(:rash, "as ruby hashes", self)
    end # class Rash

    require "alf/renderer/text"
    require "alf/renderer/yaml"
  end # module Renderer

  ############################################################################# OPERATORS
  #
  # Operators are dataflow elements that transform input tuples. They are all
  # Enumerable of tuples.
  #
  
  #
  # Marker for all operators on relations.
  # 
  module Operator
    include Iterator, TupleTools
    
    # Operators input datasets
    attr_accessor :datasets
    
    # Optional environment
    attr_accessor :environment
    
    # 
    # Sets the operator input
    #
    def pipe(input, env = environment)
      raise NotImplementedError, "Operator#pipe should be overriden"
    end
    
    #
    # Yields each tuple in turn 
    #
    # This method is implemented in a way that ensures that all operators are 
    # thread safe. It is not intended to be overriden, use _each instead.
    # 
    def each
      op = self.dup
      op._prepare
      op._each(&Proc.new)
    end

    # 
    # Executes this operator as a commandline
    #
    def execute(args)
      set_args(args)
      if r = requester
        chain = [
          r.renderer,
          self,
          _input_from_requester(r)
        ]
        r.chain(*chain).execute($stdout)
      else
        self
      end
    end

    #
    # Configures the operator from arguments taken from command line. 
    #
    # This method is intended to be overriden by subclasses and must return the 
    # operator itself.
    #
    def set_args(args)
      self
    end

    protected
    
    def _input_from_requester(r)
      r.input
    end
    
    #
    # Prepares the iterator before subsequent call to _each.
    #
    # This method is intended to be overriden by suclasses to install what's 
    # need for successful iteration. The default implementation does nothing.
    #
    def _prepare 
    end

    # Internal implementation of the iterator.
    #
    # This method must be implemented by subclasses. It is safe to use instance
    # variables (typically initialized in _prepare) here.
    # 
    def _each
    end

    # 
    # Specialization of Operator for operators that work on a unary input
    #
    module Unary
      include Operator 
      
      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = [ Iterator.coerce(input, env) ]
      end

      protected
      
      def _input_from_requester(r)
        r.input.first
      end
    
      #
      # Simply returns the first dataset
      #
      def input
        @datasets.first
      end
      
      # 
      # Yields the block with each input tuple.
      #
      # This method should be preferred to <code>input.each</code> when possible.
      #
      def each_input_tuple
        input.each(&Proc.new)
      end
      
    end # module Unary
    
    # 
    # Specialization of Operator for operators that work on a binary input
    #
    module Binary
      include Operator 
      
      # Returns the left operand
      def left
        datasets.first
      end
      
      # Returns the right operand
      def right
        datasets.last
      end
      
      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = input.collect{|a| Iterator.coerce(a, env)}
      end

    end # module Binary
    
    #
    # Specialization of Operator for operators that simply convert single tuples 
    # to single tuples.
    #
    module Transform
      include Unary
  
      protected 
  
      # @see Operator#_each
      def _each
        each_input_tuple do |tuple|
          yield _tuple2tuple(tuple)
        end
      end
  
      #
      # Transforms an input tuple to an output tuple
      #
      def _tuple2tuple(tuple)
      end
  
    end # module Transform

    #
    # Specialization of Operator for implementing operators that rely on a 
    # cesure algorithm.
    #
    module Cesure
      include Unary
      
      protected

      # @see Operator#_each
      def _each
        receiver, proj_key, prev_key = Proc.new, cesure_key, nil
        each_input_tuple do |tuple|
          cur_key = proj_key.project(tuple)
          if cur_key != prev_key
            flush_cesure(prev_key, receiver) unless prev_key.nil?
            start_cesure(cur_key, receiver)
            prev_key = cur_key
          end
          accumulate_cesure(tuple, receiver)
        end
        flush_cesure(prev_key, receiver) unless prev_key.nil?
      end

      def cesure_key
      end

      def start_cesure(key, receiver)
      end

      def accumulate_cesure(tuple, receiver)
      end

      def flush_cesure(key, receiver)
      end

    end # module Cesure

    #
    # Specialization of Operator for operators that are 
    # shortcuts on longer expressions.
    # 
    module Shortcut
      include Operator, Lispy

      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = input
      end

      protected 

      # @see Operator#_each
      def _each
        longexpr.each(&Proc.new)
      end

    end # module Shortcut

  end # module Operator

  #################################################### non relational operators
  
  # 
  # Normalize input tuples by forcing default values on missing 
  # attributes
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 VAL1 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   # Non strict mode
  #   (defaults enum, :x => 1, :y => 'hello')
  #
  #   # Strict mode (--strict)
  #   (defaults enum, {:x => 1, :y => 'hello'}, true)
  #
  # DESCRIPTION
  #
  # This operator rewrites tuples so as to ensure that all values for specified 
  # attributes ATTRx are defined and not nil. Missing or nil attributes are 
  # replaced by the associated default value VALx.
  #
  # When used in shell, the hash of default values is built from commandline
  # arguments ala Hash[...]. However, to keep type safety VALx are interpreted
  # as ruby literals and built with Kernel.eval. This means that strings must 
  # be doubly quoted. For the example of the API section:
  #
  #   alf defaults x 1 y "'hello'"
  #
  # When used in --strict mode, the operator simply project resulting tuples on
  # attributes for which a default value has been specified. Using the strict 
  # mode guarantess that the heading of all tuples is the same, and that no nil
  # value ever remains. However, this operator never remove duplicates. 
  #
  class Defaults < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Default values as a ATTR -> VAL hash 
    attr_accessor :defaults
    
    # Strict mode?
    attr_accessor :strict
    
    # Builds a Defaults operator instance
    def initialize(defaults = {}, strict = false)
      @defaults = defaults
      @strict = strict
    end
    
    options do |opt|
      opt.on('-s', '--strict', 'Strictly restrict to default attributes'){ 
        self.strict = true 
      }
    end

    # @see Operator#set_args
    def set_args(args)
      @defaults = tuple_collect(args.each_slice(2)) do |k,v|
        [k.to_sym, Kernel.eval(v)]
      end
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      if strict
        tuple_collect(@defaults){|k,v| 
          [k, coalesce(tuple[v], v)] 
        }
      else
        @defaults.merge tuple_collect(tuple){|k,v| 
          [k, coalesce(v, @defaults[k])]
        }
      end
    end

  end # class Defaults

  # 
  # 
  # Remove tuple duplicates from input tuples
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # API & EXAMPLE
  #
  #   (no_duplicates enum)
  #
  # DESCRIPTION
  #
  # This operator remove duplicates from input tuples. As defaults, it is a non
  # relational operator that helps normalizing input for implementing relational
  # operators. This one is centric in converting bags of tuples to sets of 
  # tuples, as required by true relations.
  #
  class NoDuplicates < Factory::Operator(__FILE__, __LINE__)
    include Operator::Shortcut

    # Removes duplicates according to a complete order
    class SortBased
      include Operator::Cesure      

      def cesure_key
        @cesure_key ||= ProjectionKey.new([],true)
      end

      def accumulate_cesure(tuple, receiver)
        @tuple = tuple
      end

      def flush_cesure(key, receiver)
        receiver.call(@tuple)
      end

    end # class SortBased

    # Removes duplicates by loading all in memory and filtering 
    # them there 
    class BufferBased
      include Operator::Unary

      def _prepare
        @tuples = input.to_a.uniq
      end

      def _each
        @tuples.each(&Proc.new)
      end

    end # class BufferBased

    protected 
    
    def longexpr
      chain BufferBased.new,
            datasets
    end

  end # class NoDuplicates

  # 
  # Sort input tuples according to a sort key
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ORDER1 ATTR2 ORDER2...
  #
  # API & EXAMPLE
  #
  #   # sort on supplier name in ascending order
  #   (sort [:name])
  #
  #   # sort on city then on name
  #   (sort [:city, :name])
  # 
  #   # sort on city DESC then on name ASC
  #   (sort [[:city, :desc], [:name, :asc]])
  #
  #   => See OrderingKey about specifying orderings
  #
  # DESCRIPTION
  #
  # This operator sorts input tuples on ATTR1 then ATTR2, etc. and outputs 
  # them sorted after that. This is, of course, a non relational operator as 
  # relations are unordered sets. It is provided to implement operators that
  # need tuples to be sorted to work correctly. When used in shell, the key 
  # ordering must be specified in its longest form:
  #
  #   alf sort name asc
  #   alf sort city desc name asc
  #
  # LIMITATIONS
  #
  # The fact that the ordering must be completely specified with commandline
  # arguments is a limitation, shortcuts could be provided in the future.
  #
  class Sort < Factory::Operator(__FILE__, __LINE__)
    include Operator::Unary
  
    def initialize(ordering_key = [])
      @ordering_key = OrderingKey.coerce(ordering_key)
      yield self if block_given?
    end
  
    def ordering=(ordering)
      @ordering_key = OrderingKey.coerce(ordering)
    end
  
    def set_args(args)
      self.ordering = args.collect{|c| c.to_sym}.each_slice(2).to_a
      self
    end
  
    protected 
  
    def _prepare
      @buffer = Buffer::Sorted.new(@ordering_key)
      @buffer.add_all(input)
    end
  
    def _each
      @buffer.each(&Proc.new)
    end
  
  end # class Sort

  # 
  # Clip input tuples to some attributes only
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   # Keep only name and city attributes
  #   (clip enum, [:name, :city])
  #
  #   # Keep all but name and city attributes
  #   (clip enum, [:name, :city], true)
  #
  # DESCRIPTION
  #
  # This operator clips tuples on attributes whose names are specified as 
  # arguments. This is similar to the relational PROJECT operator, expect
  # that this one does not removed duplicates that can occur from clipping.
  # In other words, clipping may lead to bags of tuples instead of sets.
  # 
  # When used in shell, the clipping/projection key is simply taken from
  # commandline arguments:
  #
  #   alf clip name city
  #   alf clip --allbut name city
  #
  class Clip < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Builds a Clip operator instance
    def initialize(attributes = [], allbut = false)
      @projection_key = ProjectionKey.new(attributes, allbut)
      yield self if block_given?
    end

    def attributes=(attrs)
      @projection_key.attributes = attrs
    end

    def allbut=(allbut)
      @projection_key.allbut = allbut
    end

    # Installs the options
    options do |opt|
      opt.on('-a', '--allbut', 'Apply a ALLBUT clipping') do
        self.allbut = true
      end
    end

    # @see Operator#set_args
    def set_args(args)
      self.attributes = args.collect{|a| a.to_sym}
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      @projection_key.project(tuple)
    end

  end # class Clip

  ################################################################## relational

  # 
  # Relational projection
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   # Project on name and city attributes
  #   (project :suppliers, [:name, :city])
  #
  #   # Project on all but name and city attributes
  #   (allbut :suppliers, [:name, :city])
  #
  # DESCRIPTION
  #
  # This operator projects tuples on attributes whose names are specified as 
  # arguments. This is similar to clip, except that this ones is a truly 
  # relational one, that is, it also removes duplicates tuples. 
  # 
  # When used in shell, the clipping/projection key is simply taken from
  # commandline arguments:
  #
  #   alf --input=suppliers project name city
  #   alf --input=suppliers project --allbut name city
  #
  class Project < Factory::Operator(__FILE__, __LINE__)
    include Operator::Shortcut, Operator::Unary
  
    # Builds a Project operator instance
    def initialize(attributes = [], allbut = false)
      @projection_key = ProjectionKey.new(attributes, allbut)
      yield self if block_given?
    end
  
    def attributes=(attrs)
      @projection_key.attributes = attrs
    end
  
    def allbut=(allbut)
      @projection_key.allbut = allbut
    end
  
    # Installs the options
    options do |opt|
      opt.on('-a', '--allbut', 'Apply a ALLBUT projection') do
        self.allbut = true
      end
    end
  
    # @see Operator#set_args
    def set_args(args)
      self.attributes = args.collect{|a| a.to_sym}
      self
    end
  
    protected 
  
    # @see Operator::Shortcut#longexpr
    def longexpr
      chain NoDuplicates.new,
            Clip.new(@projection_key.attributes, @projection_key.allbut),
            datasets
    end
  
  end # class Project
  
  # Extend input tuples with attributes whose value is computed
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 EXPR1 ATTR2 EXPR2...
  #
  # API & EXAMPLE
  #
  #   (extend :supplies, :sp  => lambda{ sid + "/" + pid },
  #                      :big => lambda{ qty > 100 ? true : false }) 
  #
  # DESCRIPTION
  #
  # This command extend input tuples with new attributes (named ATTR1, ...)  
  # whose value is the result of evaluating tuple expressions (i.e. EXPR1, ...).
  # See main documentation about the semantics of tuple expressions. When used
  # in shell, the hash of extensions is built from commandline arguments ala
  # Hash[...]. Tuple expressions must be specified as code literals there:
  #
  #   alf --input=supplies extend sp 'sid + "/" + pid' big "qty > 100 ? true : false"
  #
  # Attributes ATTRx should not already exist, no behavior is guaranteed if 
  # this precondition is not respected.   
  #
  class Extend < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Extensions as a Hash attr => lambda{...}
    attr_accessor :extensions

    # Builds an Extend operator instance
    def initialize(extensions = {})
      @extensions = extensions
    end

    # @see Operator#set_args
    def set_args(args)
      @extensions = tuple_collect(args.each_slice(2)){|k,v|
        [k.to_sym, TupleHandle.compile(v)]
      }
      self
    end

    protected 

    # @see Operator#_prepare
    def _prepare
      @handle = TupleHandle.new
    end

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      tuple.merge tuple_collect(@extensions){|k,v|
        [k, @handle.set(tuple).evaluate(v)]
      }
    end

  end # class Extend

  # 
  # Rename attributes
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} OLD1 NEW1 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   (rename :suppliers, :name => :supplier_name, :city => :supplier_city)
  #
  # DESCRIPTION
  #
  # This command renames OLD attributes as NEW as specified by arguments. 
  # Attributes OLD should exist in source tuples while attributes NEW should 
  # not. When used in shell, renaming attributes are built ala Hash[...] from
  # commandline arguments: 
  #
  #   alf --input=suppliers rename name supplier_name city supplier_city
  #
  class Rename < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Hash of source -> target attribute renamings
    attr_accessor :renaming

    # Builds a Rename operator instance
    def initialize(renaming = {})
      @renaming = renaming
    end

    # @see Operator#set_args
    def set_args(args)
      @renaming = Hash[*args.collect{|c| c.to_sym}]
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      tuple_collect(tuple){|k,v| [@renaming[k] || k, v]}
    end

  end # class Rename

  # 
  # Restrict input tuples to those to which a predicate evaluates to true
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} EXPR
  #   #{program_name} #{command_name} ATTR1 VAL1 ...
  #
  # API & EXAMPLE
  #
  #   # Restrict to suppliers with status greater than 20
  #   (restrict :suppliers, lambda{ status > 20 })
  #
  #   # Restrict to suppliers that live in London
  #   (restrict :suppliers, lambda{ city == 'London' })
  #
  # DESCRIPTION
  #
  # This command restricts tuples to those for which EXPR evaluates to true.
  # EXPR must be a valid tuple expression that should return a truth-value.
  # When used in shell, the predicate is taken as a string and compiled with
  # TupleHandle.compile. We also provide a shortcut for equality expressions. 
  # Note that, in that case, values are expected to be ruby code literals,
  # evaluated with Kernel.eval. Therefore, strings must be doubly quoted.  
  #
  #   alf --input=suppliers restrict "status > 20"
  #   alf --input=suppliers restrict city "'London'"
  #
  class Restrict < Factory::Operator(__FILE__, __LINE__)
    include Unary
    
    # Restriction predicate
    attr_accessor :predicate

    # Builds a Restrict operator instance
    def initialize(predicate = "true")
      @predicate = TupleHandle.compile(predicate)
      yield self if block_given?
    end

    # @see Operator#set_args
    def set_args(args)
      @predicate = if args.size > 1
        TupleHandle.compile  tuple_collect(args.each_slice(2)){|a,expr|
          [a, Kernel.eval(expr)]
        }
      else
        TupleHandle.compile(args.first)
      end
      self
    end

    protected 

    # @see Operator#_each
    def _each
      handle = TupleHandle.new
      each_input_tuple{|t| yield(t) if handle.set(t).evaluate(@predicate) }
    end

  end # class Restrict

  # 
  # Nest some attributes as a new TUPLE-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ... NEWNAME
  #
  # API & EXAMPLE
  #
  #   (nest :suppliers, [:city, :status], :loc_and_status)
  #
  # DESCRIPTION
  #
  # This operator nests attributes ATTR1 to ATTRN as a new, tuple-based
  # attribute whose name is NEWNAME. When used in shell, names of nested 
  # attributes are taken from commandline arguments, expected the last one
  # which defines the new name to use:
  #
  #   alf --input=suppliers nest city status loc_and_status
  #
  class Nest < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Array of nesting attributes
    attr_accessor :attributes

    # New name for the nested attribute
    attr_accessor :as

    # Builds a Nest operator instance
    def initialize(attributes = [], as = :nested)
      @attributes = attributes
      @as = as
    end

    # @see Operator#set_args
    def set_args(args)
      @as = args.pop.to_sym
      @attributes = args.collect{|a| a.to_sym}
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      others = tuple_collect(tuple.keys - @attributes){|k| [k,tuple[k]] }
      others[as] = tuple_collect(attributes){|k| [k, tuple[k]] }
      others
    end

  end # class Nest

  # 
  # Unnest a TUPLE-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR
  #
  # API & EXAMPLE
  #
  #   # Assuming nested = (nest :suppliers, [:city, :status], :loc_and_status) 
  #   (unnest nested, :loc_and_status)
  #
  # DESCRIPTION
  #
  # This operator unnests the tuple-valued attribute named ATTR so as to 
  # flatten its pairs with 'upstream' tuple. The latter should be such so that
  # no name collision occurs. When used in shell, the name of the attribute to
  # unnest is taken as the first commandline argument:
  #
  #   alf --input=nest unnest loc_and_status
  #
  class Unnest < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Name of the attribute to unnest
    attr_accessor :attribute

    # Builds a Rename operator instance
    def initialize(attribute = :nested)
      @attribute = attribute
    end

    # @see Operator#set_args
    def set_args(args)
      @attribute = args.first.to_sym
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
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
  # API & EXAMPLE
  #
  #   (group :supplies, [:pid, :qty], :supplying)
  #
  # DESCRIPTION
  #
  # This operator groups attributes ATTR1 to ATTRN as a new, relation-valued
  # attribute whose name is NEWNAME. When used in shell, names of grouped
  # attributes are taken from commandline arguments, expected the last one
  # which defines the new name to use:
  #
  #   alf --input=supplies group pid qty supplying
  #
  class Group < Factory::Operator(__FILE__, __LINE__)
    include Unary
    
    # Attributes on which grouping applies
    attr_accessor :attributes
  
    # Attribute name for grouping tuple 
    attr_accessor :as

    # Creates a Group instance
    def initialize(attributes = [], as = :group)
      @attributes = attributes
      @as = as
    end

    # @see Operator#set_args
    def set_args(args)
      @as = args.pop.to_sym
      @attributes = args.collect{|a| a.to_sym}
      self
    end

    protected

    # See Operator#_prepare
    def _prepare
      pkey = ProjectionKey.new(attributes, as)
      @index = Hash.new{|h,k| h[k] = []} 
      each_input_tuple do |tuple|
        key, rest = pkey.split(tuple)
        @index[key] << rest
      end
    end

    # See Operator#_each
    def _each
      @index.each_pair do |k,v|
        yield(k.merge(@as => v))
      end
    end

  end # class Group

  # 
  # Ungroup a RELATION-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR
  #
  # API & EXAMPLE
  #
  #   # Assuming grouped = (group enum, [:pid, :qty], :supplying)
  #   (ungroup grouped, :supplying)
  #
  # DESCRIPTION
  #
  # This operator ungroups the relation-valued attribute named ATTR and outputs
  # tuples as the flattening of each of of its tuples merged with the upstream
  # one. Sub relation should be such so that no name collision occurs. When 
  # used in shell, the name of the attribute to ungroup is taken as the first 
  # commandline argument:
  #
  #   alf --input=group ungroup supplying
  #
  class Ungroup < Factory::Operator(__FILE__, __LINE__)
    include Unary
    
    # Relation-value attribute to ungroup
    attr_accessor :attribute
  
    # Creates a Group instance
    def initialize(attribute = :grouped)
      @attribute = attribute
    end

    # @see Operator#set_args
    def set_args(args)
      @attribute = args.pop.to_sym
      self
    end

    protected 

    # See Operator#_each
    def _each
      each_input_tuple do |tuple|
        tuple = tuple.dup
        subrel = tuple.delete(@attribute)
        subrel.each do |subtuple|
          yield(tuple.merge(subtuple))
        end
      end
    end

  end # class Ungroup

  # 
  # Summarize tuples by a key and compute aggregations
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} --by=KEY1,KEY2... AGG1 EXPR1...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   (summarize :supplies, [:sid],
  #                         :total_qty => Aggregator.sum(:qty))
  #
  # DESCRIPTION
  #
  # This operator summarizes input tuples on the projection on KEY1,KEY2,...
  # attributes and applies aggregate operators on sets of matching tuples.
  # Introduced names AGG should be disjoint from KEY attributes.
  #
  # When used in shell, the aggregations are taken from commandline arguments
  # AGG and EXPR, where AGG is the name of a new attribute and EXPR is an
  # aggregation expression evaluated on Aggregator:
  #
  #   alf --input=supplies summarize --by=sid total_qty "sum(:qty)" 
  #
  class Summarize < Factory::Operator(__FILE__, __LINE__)
    include Operator::Shortcut, Operator::Unary
    
    # By attributes
    attr_accessor :by
    
    # Aggregations as a AGG => Aggregator(EXPR) hash 
    attr_accessor :aggregators

    def initialize(by = [], aggregators = {})
      @by = by
      @aggregators = aggregators
    end

    # Installs the options
    options do |opt|
      opt.on('--by=x,y,z', 'Specify by attributes', Array) do |args|
        @by = args.collect{|a| a.to_sym}
      end
    end

    # @see Operator#set_args
    def set_args(args)
      @aggregators = tuple_collect(args.each_slice(2)) do |a,expr|
        [a.to_sym, Aggregator.compile(expr)]
      end
      self
    end

    # Summarizes according to a complete order
    class SortBased
      include Alf::Operator::Cesure      

      attr_reader :cesure_key
      attr_reader :aggregators     

      def initialize(by_key, aggregators)
        @cesure_key, @aggregators = by_key, aggregators
      end

      protected 

      def start_cesure(key, receiver)
        @aggs = tuple_collect(@aggregators) do |a,agg|
          [a, agg.least]
        end
      end

      def accumulate_cesure(tuple, receiver)
        @aggs = tuple_collect(@aggregators) do |a,agg|
          [a, agg.happens(@aggs[a], tuple)]
        end
      end

      def flush_cesure(key, receiver)
        @aggs = tuple_collect(@aggregators) do |a,agg|
          [a, agg.finalize(@aggs[a])]
        end
        receiver.call key.merge(@aggs)
      end

    end # class SortBased

    protected 
    
    def longexpr
      by_key = ProjectionKey.new(@by, false)
      chain SortBased.new(by_key, @aggregators),
            Sort.new(by_key.to_ordering_key),
            datasets
    end

  end # class Summarize

  # 
  # Compute quota values on input tuples
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} --by=KEY1,... --order=OR1... AGG1 EXPR1...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   (quota :supplies, [:sid], [:qty],
  #                     :position => Aggregator.count,
  #                     :sum_qty  => Aggregator.sum(:qty))
  #
  # DESCRIPTION
  #
  # This operator computes quota values on input tuples.
  #
  #   alf --input=supplies quota --by=sid --order=qty position count sum_qty "sum(:qty)"
  #
  class Quota < Factory::Operator(__FILE__, __LINE__)
    include Operator::Shortcut, Operator::Unary

    # Quota by
    attr_accessor :by

    # Quota order
    attr_accessor :order
    
    # Quota aggregations
    attr_accessor :aggregators

    def initialize(by = [], order = [], aggregators = {})
      @by, @order, @aggregators  = by, order, aggregators
    end

    options do |opt|
      opt.on('--by=x,y,z', 'Specify by attributes', Array) do |args|
        @by = args.collect{|a| a.to_sym}
      end
      opt.on('--order=x,y,z', 'Specify order attributes', Array) do |args|
        @order = args.collect{|a| a.to_sym}
      end
    end

    # @see Operator#set_args
    def set_args(args)
      @aggregators = tuple_collect(args.each_slice(2)) do |a,expr|
        [a.to_sym, Aggregator.compile(expr)]
      end
      self
    end

    class SortBased
      include Operator::Cesure
      
      def initialize(by, order, aggregators)
        @by, @order, @aggregators  = by, order, aggregators
      end
      
      def cesure_key
        ProjectionKey.coerce @by
      end
      
      def ordering_key
        OrderingKey.coerce @order
      end
  
      def start_cesure(key, receiver)
        @aggs = tuple_collect(@aggregators) do |a,agg|
          [a, agg.least]
        end
      end
  
      def accumulate_cesure(tuple, receiver)
        @aggs = tuple_collect(@aggregators) do |a,agg|
          [a, agg.happens(@aggs[a], tuple)]
        end
        thisone = tuple_collect(@aggregators) do |a,agg|
          [a, agg.finalize(@aggs[a])]
        end
        receiver.call tuple.merge(thisone)
      end

    end # class SortBased

    protected
    
    def cesure_key
      ProjectionKey.coerce @by
    end
    
    def ordering_key
      OrderingKey.coerce @order
    end

    def longexpr
      chain SortBased.new(@by, @order, @aggregators),
            Sort.new(cesure_key.to_ordering_key + ordering_key),
            datasets
    end 

  end # class Quota

  # 
  # Relational join
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   (join :suppliers, :parts)
  #
  # DESCRIPTION
  #
  # This operator computes the (natural) join of two input iterators. Natural
  # join means that, unlike what is commonly used in SQL, the default behavior 
  # is to join on common attributes. You can use the rename operator if this
  # behavior does not fit your needs.
  #
  #   alf --input=suppliers,supplies join
  #  
  class Join < Factory::Operator(__FILE__, __LINE__)
    include Operator::Shortcut
    
    class HashBased
      include Operator::Binary
    
      class JoinBuffer
        
        def initialize(enum)
          @buffer = nil
          @key = nil
          @enum = enum
        end
        
        def split(tuple)
          _init(tuple) unless @key
          @key.split(tuple)
        end
        
        def each(key)
          @buffer[key].each(&Proc.new) if @buffer.has_key?(key)
        end
        
        private
        
        def _init(right)
          @buffer = Hash.new{|h,k| h[k] = []}
          @enum.each do |left|
            @key = ProjectionKey.coerce(left.keys & right.keys) unless @key
            @buffer[@key.project(left)] << left
          end
        end
        
      end
      
      protected
      
      def _each
        buffer = JoinBuffer.new(right)
        left.each do |left_tuple|
          key, rest = buffer.split(left_tuple)
          buffer.each(key) do |right|
            yield(left_tuple.merge(right))
          end
        end
      end
      
    end
    
    protected
    
    # @see Shortcut#longexpr
    def longexpr
      chain HashBased.new,
            datasets 
    end
    
  end # class Join
  
  ############################################################################# OTHER COMMANDS
  #
  # Below are general purpose commands provided by alf.
  #

  # 
  # Output input tuples through a specific renderer
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} [DATASET...]
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # When dataset names are specified as commandline args, request the environment 
  # to provide those datasets and print them. Otherwise, take what alf main command 
  # would provide from its --input option (defaults to stdin).
  #
  # Note that this command is not an operator and should not be piped anymore.
  #
  class Show < Factory::Command(__FILE__, __LINE__)

    options do |opt|
      @renderer = Renderer::Text
      Renderer.each_renderer do |name,descr,clazz|
        opt.on("--#{name}", "Render output #{descr}"){ @renderer = clazz }
      end
    end
      
    def execute(args)
      args = if args.empty?
        requester.input
      else
        args
      end
      args.each do |input|
        chain = [
          @renderer.new,
          input
        ]
        requester.chain(*chain).execute($stdout)
      end
    end
  
  end # class Show

  # 
  # Executes an .alf file on current environment
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} [FILE]
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This command executes the .alf file passed as first argument (or what comes
  # on standard input) as a alf query to be executed on the current environment.
  #
  class Exec < Factory::Command(__FILE__, __LINE__)
    
    def execute(args)
      chain = [ 
        requester.renderer, 
        Reader.alf(args.first || $stdin, requester.environment)
      ]
      requester.chain(*chain).execute($stdout)
    end
    
  end # class Exec
  
  # 
  # Show help about a specific command
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} COMMAND
  #
  class Help < Factory::Command(__FILE__, __LINE__)
    
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

  ############################################################################# MAIN
  #
  # Below is alf main command
  #
  include Lispy

  # Environment instance to use to get base iterators
  attr_reader :environment

  # Input dataset names
  attr_reader :input
  
  # Output renderer
  attr_reader :renderer
  
  # Creates a command instance
  def initialize(env = Environment.default)
    @environment = env
  end
  
  # Install options
  options do |opt|
    @renderer = Renderer::Rash.new
    names = Renderer.renderer_names
    opt.on('--render=RENDERER', names.collect{|n| n.to_sym},
           "Specify the renderer to use (#{names.join(', ')})") do |name|
      @renderer = Renderer.renderer_by_name(name).new
    end
    
    @input = [ $stdin ]
    opt.on('--input=x,y,z', 
           'Specify input dataset names (defaults to stdin)', Array) do |input|
      @input = input
    end
    
    opt.on_tail("--help", "Show help") do
      raise Quickl::Help
    end
    
    opt.on_tail("--version", "Show version") do
      raise Quickl::Exit, "#{program_name} #{Alf::VERSION}"\
                          " (c) 2011, Bernard Lambeau"
    end
  end # Alf's options
  
end # class Alf