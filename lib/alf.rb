require "enumerator"
require "stringio"
require "set"
require "alf/version"
require "alf/loader"

#
# Classy data-manipulation dressed in a DSL (+ commandline)
#
module Alf
  
  #
  # Provides tooling methods that are used here and there in Alf.
  # 
  module Tools
    
    #
    # Helper to define methods with multiple signatures. 
    #
    # Example:
    #
    #   varargs([1, "hello"], [Integer, String]) # => [1, "hello"]
    #   varargs(["hello"],    [Integer, String]) # => [nil, "hello"]
    # 
    def varargs(args, types)
      types.collect{|t| t===args.first ? args.shift : nil}
    end
    
    #
    # Attempt to require(who) the most friendly way as possible.
    #
    def friendly_require(who, dep = nil, retried = false)
      gem(who, dep) if dep && defined?(Gem)
      require who
    rescue LoadError => ex
      if retried
        raise "Unable to require #{who}, which is now needed\n"\
              "Try 'gem install #{who}'"
      else
        require 'rubygems' unless defined?(Gem)
        friendly_require(who, dep, true)
      end
    end

    # Returns the unqualified name of a ruby class or module
    #
    # Example
    #
    #   class_name(Alf::Tools) -> :Tools
    #
    def class_name(clazz)
      clazz.name.to_s =~ /([A-Za-z0-9_]+)$/
      $1.to_sym
    end
    
    #
    # Converts an unqualified class or module name to a ruby case method name.
    #
    # Example
    #
    #    ruby_case(:Alf)  -> "alf"
    #    ruby_case(:HelloWorld) -> "hello_world"
    # 
    def ruby_case(s)
      s.to_s.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1]
    end
    
    #
    # Returns the first non nil values from arguments
    #
    # Example
    #
    #   coalesce(nil, 1, "abc") -> 1
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
    # Defines a projection key
    # 
    class ProjectionKey
      include Tools
    
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
          x, y = t1[attr], t2[attr]
          comp = x.respond_to?(:<=>) ? (x <=> y) : (x.to_s <=> y.to_s)
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

    extend Tools
  end # module Tools
  
  #
  # Builds and returns a lispy engine on a specific environment.
  #
  # Example(s):
  #
  #   # Returns a lispy instance on the default environment
  #   lispy = Alf.lispy
  #
  #   # Returns a lispy instance on the examples' environment
  #   lispy = Alf.lispy(Alf::Environment.examples)
  #
  #   # Returns a lispy instance on a folder environment of your choice
  #   lispy = Alf.lispy(Alf::Environment.folder('path/to/a/folder'))
  #
  # @see Alf::Environment about available environments and their contract
  #
  def self.lispy(env = Alf::Environment.default)
    Command::Main.new(env)
  end

  #
  # Encapsulates the interface with the outside world, providing base iterators
  # for named datasets, among others.
  #
  # An environment is typically obtained through the factory defined by this
  # class:
  #
  #   # Returns the default environment (examples, for now)
  #   Alf::Environment.default
  #
  #   # Returns an environment on Alf's examples
  #   Alf::Environment.examples
  #
  #   # Returns an environment on a specific folder, automatically
  #   # resolving datasources via Readers' recognized file extensions
  #   Alf::Environment.folder('path/to/a/folder')
  #
  # You can implement your own environment by subclassing this class and 
  # implementing the {#dataset} method. As additional support is implemented 
  # in the base class, Environment should never be mimiced.
  # 
  class Environment
    
    # Registered environments
    @@environments = []
    
    #
    # Register an environment class
    #
    # @param [Symbol] name name of the environment kind
    # @param [Class] clazz class that implemented the environment
    #
    def self.register(name, clazz)
      @@environments << [name, clazz]
      (class << self; self; end).
        send(:define_method, name) do |*args|
          clazz.new(*args)
        end
    end
    
    #
    # Auto-detect the environment to use for specific arguments.
    #
    # @return [Environment] an environment instance
    #
    def self.autodetect(*args)
      @@environments.each do |name,clazz|
        return clazz.new(*args) if clazz.recognizes?(args)
      end
      raise ArgumentError, "Unable to auto-detect Environment with #{args.inspect}"
    end
    
    #
    # Returns a dataset whose name is provided.
    #
    # This method resolves named datasets to tuple enumerables. When the 
    # dataset exists, this method must return an Iterator, typically a 
    # Reader instance. Otherwise, it must throw a NoSuchDatasetError.
    #
    # @param [Symbol] name the name of a dataset
    # @return [Iterator] an iterator, typically a Reader instance
    # @raise [NoSuchDatasetError] when the dataset does not exists
    #
    def dataset(name)
    end
    undef :dataset
    
    #
    # Branches this environment and puts some additional explicit 
    # definitions.
    #
    # This method is provided for (with ...) expressions and should not
    # be overriden by subclasses.
    #
    # @param [Hash] a set of (name, Iterator) pairs.
    # @return [Environment] an environment instance with new definitions set
    #
    def branch(defs)
      Explicit.new(defs, self)
    end
    
    #
    # Specialization of Environment that works with explicitely defined 
    # datasources and allow branching and unbranching.
    #
    class Explicit < Environment
      
      #
      # Creates a new environment instance with initial definitions
      # and optional child environment.
      #
      def initialize(defs = {}, child = nil)
        @defs = defs
        @child = child
      end
      
      # 
      # Unbranches this environment and returns its child
      #
      def unbranch
        @child
      end
      
      # (see Environment#dataset)
      def dataset(name)
        if @defs.has_key?(name)
          @defs[name]
        elsif @child
          @child.dataset(name)
        else
          raise "No such dataset #{name}"
        end 
      end
      
    end # class Explicit
    
    #
    # Specialization of Environment to work on files of a given folder.
    #
    # This kind of environment resolves datasets by simply looking at 
    # recognized files in a specific folder. "Recognized" files are simply
    # those for which a Reader subclass has been previously registered.
    # This environment then serves reader instances.
    #
    class Folder < Environment
      
      # 
      # (see Environment.recognizes?)
      #
      # Returns true if args contains onely a String which is an existing
      # folder.
      #
      def self.recognizes?(args)
        (args.size == 1) && 
        args.first.is_a?(String) && 
        File.directory?(args.first.to_s)
      end
      
      #
      # Creates an environment instance, wired to the specified folder.
      #
      # @param [String] folder path to the folder to use as dataset source
      #
      def initialize(folder)
        @folder = folder
      end
      
      # (see Environment#dataset)
      def dataset(name)
        if file = find_file(name)
          Reader.reader(file, self)
        else
          raise "No such dataset #{name} (#{@folder})"
        end
      end
      
      protected
      
      def find_file(name)
        # TODO: refactor this, because it allows getting out of the folder
        if File.exists?(name.to_s)
          name.to_s
        elsif File.exists?(explicit = File.join(@folder, name.to_s)) &&
              File.file?(explicit)
          explicit
        else
          Dir[File.join(@folder, "#{name}.*")].find do |f|
            File.file?(f)
          end
        end
      end
      
      Environment.register(:folder, self)
    end # class Folder
    
    #
    # Returns the default environment
    #
    def self.default
      examples
    end
    
    #
    # Returns the examples environment
    #
    def self.examples
      folder File.expand_path('../../examples/operators', __FILE__)
    end
    
  end # class Environment

  #
  # Marker module for all elements implementing tuple iterators.
  #
  # At first glance, an iterator is nothing else than an Enumerable that serves 
  # tuples (represented by ruby hashes). However, this module helps Alf's internal
  # classes to recognize enumerables that may safely be considered as tuple 
  # iterators from other enumerables. For this reason, all elements that would
  # like to participate to an iteration chain (that is, an logical operator 
  # implementation) should be marked with this module. This is the case for 
  # all Readers and Operators defined in Alf.
  #
  # Moreover, an Iterator should always define a {#pipe} method, which is the
  # natural way to define the input and execution environment of operators and 
  # readers. 
  # 
  module Iterator
    include Enumerable

    #
    # Wire the iterator input and an optional execution environment.
    #
    # Iterators (typically Reader and Operator instances) work from input data 
    # that come from files, or other operators, and so on. This method wires 
    # this input data to the iterator. Wiring is required before any attempt
    # to call each, unless autowiring occurs at construction. The exact kind of
    # input object is left at discretion of Iterator implementations.
    #
    # @param [Object] input the iterator input, at discretion of the Iterator
    #        implementation.
    # @param [Environment] environment an optional environment for resolving
    #        named datasets if needed.
    # @return [Object] self
    #
    def pipe(input, environment = nil)
      self
    end
    undef :pipe
    
    # 
    # Coerces something to an iterator
    #
    def self.coerce(arg, environment = nil)
      case arg
      when Iterator, Array
        arg
      else
        Reader.coerce(arg, environment)
      end
    end
    
    #
    # Converts this iterator to an in-memory Relation.
    #
    # @return [Relation] a relation instance, as the set of tuples
    #         that would be yield by this iterator.
    #
    def to_rel
      Relation::coerce(self)
    end
    
  end # module Iterator

  #
  # Implements an Iterator at the interface with the outside world.
  #
  # The contrat of a Reader is simply to be an Iterator. Unlike operators, 
  # however, readers are not expected to take other iterators as input, but IO 
  # objects, database tables, or something similar instead. This base class 
  # provides a default behavior for readers that works with IO objects. It can 
  # be safely extended, overriden, or even mimiced (provided that you include 
  # and implement the Iterator contract).
  #
  # This class also provides a registration mechanism to help getting Reader 
  # instances for specific file extensions. A typical scenario for using this
  # registration mechanism is as follows:
  #
  #   # Registers a reader kind named :foo, associated with ".foo" file 
  #   # extensions and the FooFileDecoder class (typically a subclass of 
  #   # Reader)
  #   Reader.register(:foo, [".foo"], FooFileDecoder)   
  #
  #   # Later on, you can request a reader instance for a .foo file, as 
  #   # illustrated below.  
  #   r = Reader.reader('/a/path/to/a/file.foo')
  #
  #   # Also, a factory method is automatically installed on the Reader class
  #   # itself. This factory method can be used with a String, or an IO object.
  #   r = Reader.foo([a path or a IO object])
  #
  class Reader
    include Iterator
  
    # Registered readers
    @@readers = []
   
    #      
    # Registers a reader class associated with specific file extensions
    #
    # Registered class must provide a constructor with the following signature 
    # <code>new(path_or_io, environment = nil)</code>. The name must be a symbol
    # which can safely be used as a ruby method name. A factory class method of 
    # that name and same signature is automatically installed on the Reader 
    # class.
    #
    # @param [Symbol] name a name for the kind of data decoded
    # @param [Array] extensions file extensions mapped to the registered reader 
    #                class (should include the '.', e.g. '.foo')
    # @param [Class] class Reader subclass used to decode this kind of files 
    #     
    def self.register(name, extensions, clazz)
      @@readers << [name, extensions, clazz]
      (class << self; self; end).
        send(:define_method, name) do |*args|
          clazz.new(*args)
        end
    end
  
    #
    # When filepath is a String, returns a reader instance for a specific file 
    # whose path is given as argument. Otherwise, delegate the call to
    # <code>coerce(filepath)</code>
    #
    # @param [String] filepath path to a file for which extension is recognized
    # @param [Array] args optional additional arguments that must be passed at
    #        reader's class new method.
    # @return [Reader] a reader instance
    # 
    def self.reader(filepath, *args)
      if filepath.is_a?(String)
        ext = File.extname(filepath)
        if registered = @@readers.find{|r| r[1].include?(ext)}
          registered[2].new(filepath, *args)
        else
          raise "No registered reader for #{ext} (#{filepath})"
        end
      elsif args.empty? 
        coerce(filepath)
      else
        raise ArgumentError, "Unable to return a reader for #{filepath} and #{args}" 
      end
    end
    
    #
    # Coerces an argument to a reader, using an optional environment to convert 
    # named datasets.
    #
    # This method automatically provides readers for Strings and Symbols through
    # passed environment (**not** through the reader factory) and for IO objects 
    # (through Rash reader). It is part if Alf's internals and should be used 
    # with care.
    #
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
    
    # Default reader options
    DEFAULT_OPTIONS = {}
    
    # @return [Environment] Wired environment 
    attr_accessor :environment
  
    # @return [String or IO] Input IO, or file name
    attr_accessor :input
    
    # @return [Hash] Reader's options
    attr_accessor :options
  
    #
    # Creates a reader instance. 
    #
    # @param [String or IO] path to a file or IO object for input
    # @param [Environment] environment wired environment, serving this reader
    # @param [Hash] options Reader's options (see doc of subclasses) 
    #
    def initialize(*args)
      @input, @environment, @options = case args.first
      when String, IO, StringIO
        Tools.varargs(args, [args.first.class, Environment, Hash])
      else
        Tools.varargs(args, [String, Environment, Hash])
      end
      @options = self.class.const_get(:DEFAULT_OPTIONS).merge(@options || {}) 
    end
  
    #
    # (see Iterator#pipe)
    #
    def pipe(input, env = environment)
      @input = input
      self
    end
    
    #
    # (see Iterator#each)
    #
    # @private the default implementation reads lines of the input stream and 
    # yields the block with <code>line2tuple(line)</code> on each of them. This 
    # method may be overriden if this behavior does not fit reader's needs.
    #
    def each
      each_input_line do |line| 
        tuple = line2tuple(line)
        yield tuple unless tuple.nil?
      end
    end
  
    protected
    
    #
    # Returns the input file path, or nil if this Reader is bound to an IO
    # directly.
    #
    def input_path
      input.is_a?(String) ? input : nil
    end

    #
    # Coerces the input object to an IO and yields the block with it.
    #
    # StringIO and IO input are yield directly while file paths are first
    # opened in read mode and then yield.
    #
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
    
    #
    # Returns the whole input text. 
    #
    # This feature should only be used by subclasses on inputs that are 
    # small enough to fit in memory. Consider implementing readers without this
    # feature on files that could be larger. 
    #
    def input_text
      with_input_io{|io| io.readlines.join}
    end
    
    #
    # Yields the block with each line of the input text in turn.
    #
    # This method is an helper for files that capture one tuple on each input 
    # line. It should be used in those cases, as the resulting reader will not
    # load all input in memory but serve tuples on demand.  
    #
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
    def line2tuple(line)
    end
    undef :line2tuple
  
    #
    # Specialization of the Reader contract for .rash files.
    #
    # A .rash file/stream contains one ruby hash literal on each line. This 
    # reader simply decodes each of them in turn with Kernel.eval, providing a 
    # state-less reader (that is, tuples are not all loaded in memory at once).
    #
    class Rash < Reader
  
      # (see Reader#line2tuple)
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
  
      Reader.register(:rash, [".rash"], self)  
    end # class Rash
  
    #
    # Specialization of the Reader contrat for .alf files.
    #
    # A .alf file simply contains a query expression in the Lispy DSL. This
    # reader decodes and compiles the expression and delegates the enumeration
    # to the obtained operator.
    #
    # Note that an Environment must be wired at creation or piping time. 
    # NoSuchDatasetError will certainly occur otherwise.  
    #
    class AlfFile < Reader
      
      # (see Reader#each)
      def each
        op = Alf.lispy(environment).compile(input_text, input_path)
        op.each(&Proc.new)
      end
      
      Reader.register(:alf, [".alf"], self)
    end # module AlfFile
  
  end # module Reader

  #
  # Renders a relation (given by any Iterator) in a specific format.
  #
  # A renderer takes an Iterator instance as input and renders it on an output
  # stream. Renderers are **not** iterators themselves, even if they mimic the
  # {#pipe} method. Their usage is made via the {#execute} method.
  #
  # Similarly to the {Reader} class, this one provides a registration mechanism
  # for specific output formats. The common scenario is as follows:
  #
  #   # Register a new renderer for :foo format (automatically provides the 
  #   # '--foo   Render output as a foo stream' option of 'alf show') and with
  #   # the FooRenderer class for handling rendering.  
  #   Renderer.register(:foo, "as a foo stream", FooRenderer)
  #
  #   # Later on, you can request a renderer instance for a specific format
  #   # as follows (wiring input is optional) 
  #   r = Renderer.renderer(:foo, [an Iterator])
  #
  #   # Also, a factory method is automatically installed on the Renderer class
  #   # itself.
  #   r = Renderer.foo([an Iterator])
  #
  class Renderer

    # Registered renderers
    @@renderers = []
    
    #
    # Register a renderering class with a given name and description.
    #
    # Registered class must at least provide a constructor with an empty 
    # signature. The name must be a symbol which can safely be used as a ruby 
    # method name. A factory class method of that name and degelation signature 
    # is automatically installed on the Renderer class.
    #
    # @param [Symbol] name a name for the output format
    # @param [String] description an output format description (for 'alf show')
    # @param [Class] clazz Renderer subclass used to render in this format 
    #     
    def self.register(name, description, clazz)
      @@renderers << [name, description, clazz]
      (class << self; self; end).
        send(:define_method, name) do |*args|
          clazz.new(*args)
        end
    end
    
    #
    # Returns a Renderer instance for the given output format name.
    #
    # @param [Symbol] name name of an output format previously registered
    # @param [...] args other arguments to pass to the renderer constructor
    # @return [Renderer] a Renderer instance, already wired if args are 
    #         provided
    #
    def self.renderer(name, *args)
      if r = @@renderers.find{|triple| triple[0] == name}
        r[2].new(*args)
      else
        raise "No renderer registered for #{name}"
      end
    end

    #
    # Yields each (name,description,clazz) previously registered in turn
    #
    def self.each_renderer
      @@renderers.each(&Proc.new)
    end
    
    # Default renderer options
    DEFAULT_OPTIONS = {}

    # Renderer input (typically an Iterator)
    attr_accessor :input
    
    # @return [Environment] Optional wired environment
    attr_accessor :environment

    # @return [Hash] Renderer's options
    attr_accessor :options
    
    #
    # Creates a reader instance. 
    #
    # @param [Iterator] iterator an Iterator of tuples to render
    # @param [Environment] environment wired environment, serving this reader
    # @param [Hash] options Reader's options (see doc of subclasses) 
    #
    def initialize(*args)
      @input, @environment, @options = case args.first
      when Array
        Tools.varargs(args, [Array, Environment, Hash])
      else
        Tools.varargs(args, [Iterator, Environment, Hash])
      end
      @options = self.class.const_get(:DEFAULT_OPTIONS).merge(@options || {}) 
    end
    
    # 
    # Sets the renderer input.
    #
    # This method mimics {Iterator#pipe} and have the same contract.
    #
    def pipe(input, env = environment)
      self.environment = env 
      self.input = input
      self
    end

    #
    # Executes the rendering, outputting the resulting tuples on the provided
    # output buffer. 
    #
    # The default implementation simply coerces the input as an Iterator and
    # delegates the call to {#render}.
    #
    def execute(output = $stdout)
      render(Iterator.coerce(input, environment), output)
    end
    
    protected
    
    #
    # Renders tuples served by the iterator to the output buffer provided and
    # returns the latter.
    #
    # This method must be implemented by subclasses unless {#execute} is 
    # overriden.
    #
    def render(iterator, output)
    end
    undef :render

    #
    # Implements the Renderer contract through inspect
    #
    class Rash < Renderer
  
      # (see Renderer#render)
      def render(input, output)
        input.each do |tuple|
          output << tuple.inspect << "\n"
        end
        output
      end
  
      Renderer.register(:rash, "as ruby hashes", self)
    end # class Rash

  end # module Renderer

  #
  # Provides a factory over Alf operators and handles the interface with
  # Quickl for commandline support.
  #
  # This module is part of Alf's internal architecture and should not be used
  # at all by third-party projects.
  # 
  module Factory
  
    # @see Quickl::Command
    def Command(file, line)
      Quickl::Command(file, line){|builder|
        builder.command_parent = Alf::Command::Main
        yield(builder) if block_given?
      }
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
  # Marker module and namespace for Alf main commands, those that are **not** 
  # operators at all. 
  #
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
    #    cmd.include?(Alf::Operator::Relational)
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
        extend(Lispy)
      end
      
      # Install options
      options do |opt|
        @execute = false
        opt.on("-e", "--execute", "Execute one line of script (Lispy API)") do 
          @execute = true
        end
        
        @renderer = Renderer::Rash.new
        Renderer.each_renderer do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){ 
            @renderer = clazz.new 
          }
        end
        
        opt.on('--env=ENV', 
               "Set the environment to use") do |value|
          @environment = Environment.autodetect(value)
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
      def _normalize(args)
        opts = []
        while !args.empty? && (args.first =~ /^\-/)
          opts << args.shift 
        end
        if args.empty? or (args.size == 1 && File.exists?(args.first))
          opts << "exec"
        end
        opts += args
      end
      
      #
      # Overrided because Quickl only keep --options but modifying it there 
      # should probably be considered a broken API.
      #
      def _run(argv = [])
        argv = _normalize(argv)
        
        # 1) Extract my options and parse them
        my_argv = []
        while argv.first =~ /^-/
          my_argv << argv.shift
        end
        parse_options(my_argv)
        
        # 2) build the operator according to -e option
        operator = if @execute
          instance_eval(argv.first)
        else
          super
        end
        
        # 3) if there is a requester, then we do the job (assuming bin/alf)
        # with the renderer to use. Otherwise, we simply return built operator
        if operator && requester
          renderer.pipe(operator, environment).execute($stdout)
        else
          operator
        end
      end
      
    end
    
    # 
    # Output input tuples through a specific renderer (text, yaml, ...)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} DATASET
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #
    # When a dataset name is specified as commandline arg, request the 
    # environment to provide this dataset and prints it. Otherwise, take what 
    # comes on standard input.
    #
    # Note that this command is not an operator and should not be piped anymore.
    #
    class Show < Factory::Command(__FILE__, __LINE__)
      include Command
    
      options do |opt|
        @renderer = Text::Renderer.new
        Renderer.each_renderer do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){ 
            @renderer = clazz.new 
          }
        end
      end
        
      def execute(args)
        requester.renderer = @renderer
        args = [ $stdin ] if args.empty?
        args.first
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
      include Command
      
      def execute(args)
        Reader.alf(args.first || $stdin, requester.environment)
      end
      
    end # class Exec
    
    # 
    # Show help about a specific command
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} COMMAND
    #
    class Help < Factory::Command(__FILE__, __LINE__)
      include Command
      
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
        nil
      end
      
    end # class Help

  end
  
  #
  # Marker for all operators, relational and non-relational ones.
  # 
  module Operator
    include Iterator, Tools
    
    #
    # Yields non-relational then relational operators, in turn.
    #
    def self.each
      Operator::NonRelational.each{|x| yield(x)}
      Operator::Relational.each{|x| yield(x)}
    end

    # 
    # Encapsulates method that allows making operator introspection, that is,
    # knowing operator cardinality and similar stuff.
    # 
    module Introspection
      
      #
      # Returns true if this operator is an unary operator, false otherwise
      #
      def unary?
        ancestors.include?(Operator::Unary)
      end

      #
      # Returns true if this operator is a binary operator, false otherwise
      #
      def binary?
        ancestors.include?(Operator::Binary)
      end
      
    end # module Introspection
    
    # Ensures that the Introspection module is set on real operators
    def self.included(mod)
      mod.extend(Introspection) if mod.is_a?(Class)
    end
    
    #
    # Encapsulates method definitions that convert operators to Quickl
    # commands
    #
    module CommandMethods
    
      protected
      
      #
      # Configures the operator from arguments taken from command line. 
      #
      # This method is intended to be overriden by subclasses and must return the 
      # operator itself.
      #
      def set_args(args)
        self
      end
      
      #
      # Overrides Quickl::Command::Single#_run to handles the '--' separator
      # correctly.
      #
      # This is because parse_options tend to eat the '--' separator... This 
      # could be handled in Quickl itself, but it should be considered a broken 
      # API and will only be available in quickl >= 0.3.0 (probably)
      #
      def _run(argv = [])
        operands, args = split_command_args(argv).collect do |arr|
          parse_options(arr)
        end
        self.set_args(args)
        if operands = command_line_operands(operands) 
          env = environment || (requester ? requester.environment : nil) 
          self.pipe(operands, env)
        end 
        self
      end
    
      def split_command_args(args)
        case (i = args.index("--"))
        when NilClass
          [args, []]
        when 0
          [[ $stdin ], args[1..-1]]
        else
          [args[0...i], args[i+1..-1]]
        end
      end
      
      def command_line_operands(operands)
        operands
      end
    
    end # module CommandMethods
    include CommandMethods
    
    # Operators input datasets
    attr_accessor :datasets
    
    # Optional environment
    attr_reader :environment
    
    # Sets the environment on this operator and propagate on
    # datasets
    def environment=(env)
      # this is to avoid infinite loop (TODO: why is there infinite loops??)
      return if @environment == env
      
      # set and propagate on children
      @environment = env
      datasets.each do |dataset|
        if dataset.respond_to?(:environment)
          dataset.environment = env
        end  
      end if datasets
      
      env
    end
    
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
    
    protected
    
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
        self.datasets = [ input ]
        self
      end

      protected
      
      def command_line_operands(operands)
        operands.first || $stdin
      end
    
      #
      # Simply returns the first dataset
      #
      def input
        Iterator.coerce(datasets.first, environment)
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
      
      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = input
        self
      end

      protected
      
      def command_line_operands(operands)
        (operands.size < 2) ? ([$stdin] + operands) : operands
      end
    
      # Returns the left operand
      def left
        Iterator.coerce(datasets.first, environment)
      end
      
      # Returns the right operand
      def right
        Iterator.coerce(datasets.last, environment)
      end
      
    end # module Binary
    
    #
    # Specialization of Operator for operators that simply convert single tuples 
    # to single tuples.
    #
    module Transform
      include Unary
  
      protected 
  
      # (see Operator#_each)
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

      # (see Operator#_each)
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
    # Specialization of Operator for operators that are shortcuts for longer 
    # expressions.
    # 
    module Shortcut
      include Operator

      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = input
        self
      end

      protected 

      # (see Operator#_each)
      def _each
        longexpr.each(&Proc.new)
      end
      
      #
      # Compiles the longer expression and returns it.
      #
      # @return (Iterator) the compiled longer expression, typically another
      #         Operator instance
      #
      def longexpr
      end 
      undef :longexpr

      #
      # This is an helper ala Lispy#chain for implementing (#longexpr).
      #
      # @param [Array] elements a list of Iterator-able 
      # @return [Operator] the first element of the list, but piped with the 
      #         next one, and so on.
      #
      def chain(*elements)
        elements = elements.reverse
        elements[1..-1].inject(elements.first) do |c, elm|
          elm.pipe(c, environment)
          elm
        end
      end
      
    end # module Shortcut

  end # module Operator

  #
  # Marker module and namespace for non relational operators
  #
  module Operator::NonRelational

    #
    # Yields the block with each operator module in turn
    #
    def self.each
      constants.each do |c|
        val = const_get(c)
        yield(val) if val.ancestors.include?(Operator::NonRelational)
      end
    end
    
    # 
    # Extend its operand with an unique autonumber attribute
    #
    # SYNOPSIS
    #
    # #{program_name} #{command_name} [OPERAND] -- [ATTRNAME]
    #
    # DESCRIPTION
    #
    # This non-relational operator guarantees uniqueness of output tuples by
    # adding an attribute called 'ATTRNAME' whose value is an Integer. No 
    # guarantee is given about ordering of output tuples, nor to the fact
    # that this autonumber is sequential. Only that all values are different.
    # If the presence of duplicates was the only "non-relational" aspect of
    # input tuples, the result may be considered a valid relation representation.
    #
    # IN RUBY
    #
    #   (autonum OPERAND, ATTRNAME = :autonum)
    #
    #   (autonum :suppliers)
    #   (autonum :suppliers, :unique_id)
    #
    # IN SHELL
    #
    #   #{program_name} #{command_name} [OPERAND] -- [ATTRNAME]
    #
    #   alf autonum suppliers
    #   alf autonum suppliers -- unique_id
    #
    class Autonum < Factory::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
    
      # Names of the new attribute to add
      attr_accessor :attrname
      
      def initialize(attrname = :autonum)
        @attrname = attrname
      end
      
      protected 
      
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @attrname = args.last.to_sym unless args.empty? 
      end
      
      # (see Operator#_prepare)
      def _prepare
        @autonum = -1
      end
      
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge(@attrname => (@autonum += 1))
      end
    
    end # class Autonum
    
    # 
    # Force default values on missing/nil attributes
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 VAL1 ...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Non strict mode
    #   (defaults :suppliers, :country => 'Belgium')
    #
    #   # Strict mode (--strict)
    #   (defaults :suppliers, {:country => 'Belgium'}, true)
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
    #   alf defaults suppliers -- country "'Belgium'"
    #
    # When used in --strict mode, the operator simply project resulting tuples on
    # attributes for which a default value has been specified. Using the strict 
    # mode guarantess that the heading of all tuples is the same, and that no nil
    # value ever remains. However, this operator never remove duplicates. 
    #
    class Defaults < Factory::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
  
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
  
      protected 
  
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @defaults = tuple_collect(args.each_slice(2)) do |k,v|
          [k.to_sym, Kernel.eval(v)]
        end
        self
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        if strict
          tuple_collect(@defaults){|k,v| 
            [k, coalesce(tuple[k], v)] 
          }
        else
          @defaults.merge tuple_collect(tuple){|k,v| 
            [k, coalesce(v, @defaults[k])]
          }
        end
      end
  
    end # class Defaults
  
    # 
    # Remove tuple duplicates
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND]
    #
    # API & EXAMPLE
    #
    #   # clip, unlike project, typically leave duplicates
    #   (compact (clip :suppliers, [ :city ]))
    #
    # DESCRIPTION
    #
    # This operator remove duplicates from input tuples. As defaults, it is a non
    # relational operator that helps normalizing input for implementing relational
    # operators. This one is centric in converting bags of tuples to sets of 
    # tuples, as required by true relations.
    #
    #   alf compact ... 
    #
    class Compact < Factory::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Shortcut, Operator::Unary
  
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
  
    end # class Compact
  
    # 
    # Sort input tuples according to an order relation
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ORDER1 ATTR2 ORDER2...
    #
    # API & EXAMPLE
    #
    #   # sort on supplier name in ascending order
    #   (sort :suppliers, [:name])
    #
    #   # sort on city then on name
    #   (sort :suppliers, [:city, :name])
    # 
    #   # sort on city DESC then on name ASC
    #   (sort :suppliers, [[:city, :desc], [:name, :asc]])
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
    #   alf sort suppliers -- name asc
    #   alf sort suppliers -- city desc name asc
    #
    # LIMITATIONS
    #
    # The fact that the ordering must be completely specified with commandline
    # arguments is a limitation, shortcuts could be provided in the future.
    #
    class Sort < Factory::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Unary
    
      def initialize(ordering_key = [])
        @ordering_key = OrderingKey.coerce(ordering_key)
        yield self if block_given?
      end
    
      def ordering=(ordering)
        @ordering_key = OrderingKey.coerce(ordering)
      end
    
      protected 
    
      def set_args(args)
        self.ordering = args.collect{|c| c.to_sym}.each_slice(2).to_a
        self
      end
    
      def _prepare
        @buffer = Buffer::Sorted.new(@ordering_key)
        @buffer.add_all(input)
      end
    
      def _each
        @buffer.each(&Proc.new)
      end
    
    end # class Sort
  
    # 
    # Clip input tuples to a subset of attributes
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Keep only name and city attributes
    #   (clip :suppliers, [:name, :city])
    #
    #   # Keep all but name and city attributes
    #   (clip :suppliers, [:name, :city], true)
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
    #   alf clip suppliers -- name city
    #   alf clip suppliers --allbut -- name city
    #
    class Clip < Factory::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
  
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
  
      protected 
  
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        self.attributes = args.collect{|a| a.to_sym}
        self
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        @projection_key.project(tuple)
      end
  
    end # class Clip

  end # Operator::NonRelational
  
  #
  # Marker module and namespace for relational operators
  #
  module Operator::Relational

    # 
    # Yields the block with each operator module in turn
    #
    def self.each
      constants.each do |c|
        val = const_get(c)
        yield(val) if val.ancestors.include?(Operator::Relational)
      end
    end
    
    # Relational projection (clip + compact)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ...
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
    #   alf project suppliers -- name city
    #   alf project --allbut suppliers -- name city
    #
    class Project < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
    
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
    
      protected 
    
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        self.attributes = args.collect{|a| a.to_sym}
        self
      end
    
      # (see Operator::Shortcut#longexpr)
      def longexpr
        chain Operator::NonRelational::Compact.new,
              Operator::NonRelational::Clip.new(@projection_key.attributes, 
                                                @projection_key.allbut),
              datasets
      end
    
    end # class Project
    
    #
    # Relational extension (additional, computed attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 EXPR1 ATTR2 EXPR2...
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
    #   alf extend supplies -- sp 'sid + "/" + pid' big "qty > 100 ? true : false"
    #
    # Attributes ATTRx should not already exist, no behavior is guaranteed if 
    # this precondition is not respected.   
    #
    class Extend < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      # Extensions as a Hash attr => lambda{...}
      attr_accessor :extensions
  
      # Builds an Extend operator instance
      def initialize(extensions = {})
        @extensions = extensions
      end
  
      protected 
    
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @extensions = tuple_collect(args.each_slice(2)){|k,v|
          [k.to_sym, TupleHandle.compile(v)]
        }
        self
      end
  
      # (see Operator#_prepare)
      def _prepare
        @handle = TupleHandle.new
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge tuple_collect(@extensions){|k,v|
          [k, @handle.set(tuple).evaluate(v)]
        }
      end
  
    end # class Extend
  
    # 
    # Relational renaming (rename some attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- OLD1 NEW1 ...
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
    #   alf rename suppliers -- name supplier_name city supplier_city
    #
    class Rename < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      # Hash of source -> target attribute renamings
      attr_accessor :renaming
  
      # Builds a Rename operator instance
      def initialize(renaming = {})
        @renaming = renaming
      end
  
      protected 
    
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @renaming = Hash[*args.collect{|c| c.to_sym}]
        self
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple_collect(tuple){|k,v| [@renaming[k] || k, v]}
      end
  
    end # class Rename
  
    # 
    # Relational restriction (aka where, predicate filtering)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- EXPR
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 VAL1 ...
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
    #   alf restrict suppliers -- "status > 20"
    #   alf restrict suppliers -- city "'London'"
    #
    class Restrict < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      # Restriction predicate
      attr_accessor :predicate
  
      # Builds a Restrict operator instance
      def initialize(predicate = "true")
        @predicate = TupleHandle.compile(predicate)
        yield self if block_given?
      end
  
      protected 
    
      # (see Operator::CommandMethods#set_args)
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
  
      # (see Operator#_each)
      def _each
        handle = TupleHandle.new
        each_input_tuple{|t| yield(t) if handle.set(t).evaluate(@predicate) }
      end
  
    end # class Restrict
  
    # 
    # Relational join (and cross-join)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
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
    #   alf join suppliers supplies 
    #  
    class Join < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
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
              @key = Tools::ProjectionKey.coerce(left.keys & right.keys) unless @key
              @buffer[@key.project(left)] << left
            end
            @key = Tools::ProjectionKey.coerce([]) unless @key
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
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Join
    
    # 
    # Relational intersection (aka a logical and)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   # Give suppliers that live in Paris and have status >= 20
    #   (intersect \\
    #     (restrict :suppliers, lambda{ status >= 20 }),
    #     (restrict :suppliers, lambda{ city == 'Paris' }))
    #
    # DESCRIPTION
    #
    # This operator computes the intersection between its two operands. The 
    # intersection is simply the set of common tuples between them. Both operands
    # must have the same heading. 
    #
    #   alf intersect ... ...
    #  
    class Intersect < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      class HashBased
        include Operator::Binary
      
        protected
        
        def _prepare
          @index = Hash.new
          right.each{|t| @index[t] = true}
        end
        
        def _each
          left.each do |left_tuple|
            yield(left_tuple) if @index.has_key?(left_tuple)
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Intersect
  
    # 
    # Relational minus (aka difference)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   # Give all suppliers but those living in Paris
    #   (minus :suppliers, 
    #          (restrict :suppliers, lambda{ city == 'Paris' }))
    #
    # DESCRIPTION
    #
    # This operator computes the difference between its two operands. The 
    # difference is simply the set of tuples in left operands non shared by
    # the right one.
    #
    #   alf minus ... ...
    #  
    class Minus < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      class HashBased
        include Operator::Binary
      
        protected
        
        def _prepare
          @index = Hash.new
          right.each{|t| @index[t] = true}
        end
        
        def _each
          left.each do |left_tuple|
            yield(left_tuple) unless @index.has_key?(left_tuple)
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Minus
  
    # 
    # Relational union
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   (union (project :suppliers, [:city]), 
    #          (project :parts,     [:city]))
    #
    # DESCRIPTION
    #
    # This operator computes the union join of two input iterators. Input 
    # iterators should have the same heading. The result never contain duplicates.
    #
    #   alf union ... ...
    #  
    class Union < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      class DisjointBased
        include Operator::Binary
      
        protected
        
        def _each
          left.each(&Proc.new)
          right.each(&Proc.new)
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain Operator::NonRelational::Compact.new,
              DisjointBased.new,
              datasets 
      end
      
    end # class Union
    
    # 
    # Relational wraping (tuple-valued attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ... NEWNAME
    #
    # API & EXAMPLE
    #
    #   (wrap :suppliers, [:city, :status], :loc_and_status)
    #
    # DESCRIPTION
    #
    # This operator wraps attributes ATTR1 to ATTRN as a new, tuple-based
    # attribute whose name is NEWNAME. When used in shell, names of wrapped 
    # attributes are taken from commandline arguments, expected the last one
    # which defines the new name to use:
    #
    #   alf wrap suppliers -- city status loc_and_status
    #
    class Wrap < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      # Array of wraping attributes
      attr_accessor :attributes
  
      # New name for the wrapped attribute
      attr_accessor :as
  
      # Builds a Wrap operator instance
      def initialize(attributes = [], as = :wrapped)
        @attributes = attributes
        @as = as
      end
  
      protected 
  
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @as = args.pop.to_sym
        @attributes = args.collect{|a| a.to_sym}
        self
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        others = tuple_collect(tuple.keys - @attributes){|k| [k,tuple[k]] }
        others[as] = tuple_collect(attributes){|k| [k, tuple[k]] }
        others
      end
  
    end # class Wrap
  
    # 
    # Relational un-wraping (inverse of wrap)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR
    #
    # API & EXAMPLE
    #
    #   # Assuming wrapped = (wrap :suppliers, [:city, :status], :loc_and_status) 
    #   (unwrap wrapped, :loc_and_status)
    #
    # DESCRIPTION
    #
    # This operator unwraps the tuple-valued attribute named ATTR so as to 
    # flatten its pairs with 'upstream' tuple. The latter should be such so that
    # no name collision occurs. When used in shell, the name of the attribute to
    # unwrap is taken as the first commandline argument:
    #
    #   alf unwrap wrap -- loc_and_status
    #
    class Unwrap < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      # Name of the attribute to unwrap
      attr_accessor :attribute
  
      # Builds a Rename operator instance
      def initialize(attribute = :wrapped)
        @attribute = attribute
      end
  
      protected 
  
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @attribute = args.first.to_sym
        self
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple = tuple.dup
        wrapped = tuple.delete(@attribute) || {}
        tuple.merge(wrapped)
      end
  
    end # class Unwrap
  
    # 
    # Relational grouping (relation-valued attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ... NEWNAME
    #
    # API & EXAMPLE
    #
    #   (group :supplies, [:pid, :qty], :supplying)
    #   (group :supplies, [:sid], :supplying, true)
    #
    # DESCRIPTION
    #
    # This operator groups attributes ATTR1 to ATTRN as a new, relation-valued
    # attribute whose name is NEWNAME. When used in shell, names of grouped
    # attributes are taken from commandline arguments, expected the last one
    # which defines the new name to use:
    #
    #   alf group supplies -- pid qty supplying
    #   alf group supplies --allbut -- sid supplying
    #
    class Group < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      # Attributes on which grouping applies
      attr_accessor :attributes
    
      # Attribute name for grouping tuple 
      attr_accessor :as
  
      # Group all but attributes? 
      attr_accessor :allbut
  
      # Creates a Group instance
      def initialize(attributes = [], as = :group, allbut = false)
        @attributes = attributes
        @as = as
        @allbut = allbut
      end
  
      options do |opt|
        opt.on('--allbut', "Group all but specified attributes"){ @allbut = true }
      end
      
      protected 
  
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @as = args.pop.to_sym
        @attributes = args.collect{|a| a.to_sym}
        self
      end
  
      # See Operator#_prepare
      def _prepare
        pkey = ProjectionKey.new(attributes, !allbut)
        @index = Hash.new{|h,k| h[k] = Set.new} 
        each_input_tuple do |tuple|
          key, rest = pkey.split(tuple)
          @index[key] << rest
        end
      end
  
      # See Operator#_each
      def _each
        @index.each_pair do |k,v|
          yield(k.merge(@as => Relation.coerce(v)))
        end
      end
  
    end # class Group
  
    # 
    # Relational un-grouping (inverse of group)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR
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
    #   alf ungroup group -- supplying
    #
    class Ungroup < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      # Relation-value attribute to ungroup
      attr_accessor :attribute
    
      # Creates a Group instance
      def initialize(attribute = :grouped)
        @attribute = attribute
      end
  
      protected 
  
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @attribute = args.pop.to_sym
        self
      end
  
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
    # Relational summarization (group-by + aggregate ops)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] [--allbut] --by=KEY1,KEY2... -- AGG1 EXPR1...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   (summarize :supplies, [:sid],
    #                         :total_qty => Aggregator.sum(:qty))
    #
    #   # Or, to specify an allbut projection
    #   (summarize :supplies, [:qty, :pid],
    #                         :total_qty => Aggregator.sum(:qty), true)
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
    #   alf summarize supplies --by=sid -- total_qty "sum(:qty)" 
    #   alf summarize supplies --allbut --by=pid,qty -- total_qty "sum(:qty)" 
    #
    class Summarize < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
      
      # By attributes
      attr_accessor :by
      
      # Allbut on by?
      attr_accessor :allbut
      
      # Aggregations as a AGG => Aggregator(EXPR) hash 
      attr_accessor :aggregators
  
      def initialize(by = [], aggregators = {}, allbut = false)
        @by = by
        @allbut = allbut
        @aggregators = aggregators
      end
  
      # Installs the options
      options do |opt|
        opt.on('--by=x,y,z', 'Specify by attributes', Array) do |args|
          @by = args.collect{|a| a.to_sym}
        end
        opt.on('--allbut', 'Make an allbut projection/summarization') do
          @allbut = true
        end
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

      # Summarizes in-memory with a hash
      class HashBased
        include Operator::Relational, Operator::Unary
        
        attr_reader :by_key
        attr_reader :aggregators     
  
        def initialize(by_key, aggregators)
          @by_key, @aggregators = by_key, aggregators
        end

        protected
        
        def _each
          index = Hash.new do |h,k|
            h[k] = tuple_collect(@aggregators) do |a,agg|
              [a, agg.least]
            end
          end
          each_input_tuple do |tuple|
            key, rest = by_key.split(tuple)
            index[key] = tuple_collect(@aggregators) do |a,agg|
              [a, agg.happens(index[key][a], tuple)]
            end
          end
          index.each_pair do |key,aggs|
            aggs = tuple_collect(@aggregators) do |a,agg|
              [a, agg.finalize(aggs[a])]
            end
            yield key.merge(aggs)
          end
        end
      
      end
        
      protected 
      
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @aggregators = tuple_collect(args.each_slice(2)) do |a,expr|
          [a.to_sym, Aggregator.compile(expr)]
        end
        self
      end
  
      def longexpr
        if @allbut
          by_key = Tools::ProjectionKey.new(@by, @allbut)
          chain HashBased.new(by_key, @aggregators),
                datasets
        else
          by_key = Tools::ProjectionKey.new(@by, @allbut)
          chain SortBased.new(by_key, @aggregators),
                Operator::NonRelational::Sort.new(by_key.to_ordering_key),
                datasets
        end
      end
  
    end # class Summarize
  
    # 
    # Relational quota-queries (position, sum progression, etc.)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] --by=KEY1,... --order=OR1... AGG1 EXPR1...
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
    #   alf quota supplies --by=sid --order=qty -- position count sum_qty "sum(:qty)"
    #
    class Quota < Factory::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
  
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
      
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        @aggregators = tuple_collect(args.each_slice(2)) do |a,expr|
          [a.to_sym, Aggregator.compile(expr)]
        end
        self
      end
  
      def cesure_key
        ProjectionKey.coerce @by
      end
      
      def ordering_key
        OrderingKey.coerce @order
      end
  
      def longexpr
        sort_key = cesure_key.to_ordering_key + ordering_key
        chain SortBased.new(@by, @order, @aggregators),
              Operator::NonRelational::Sort.new(sort_key),
              datasets
      end 
  
    end # class Quota
  
  end

  #
  # Aggregation operator.
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
      @handle = Tools::TupleHandle.new
      @options = default_options.merge(options)
      @functor = Tools::TupleHandle.compile(attribute || block)
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
    class Group < Aggregator
      def initialize(*attrs)
        super(nil, {}){
          Tools.tuple_collect(attrs){|k| [k, self.send(k)] }
        }
      end
      def least(); Set.new; end
      def _happens(memo, val)
        memo << val
      end
      def finalize(memo)
        Relation.coerce memo
      end
    end
    
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

  # 
  #
  # Defines an in-memory relation data structure.
  #
  # A relation is a set of tuples; a tuple is a set of attribute (name, value)
  # pairs. The class implements such a data structure with full relational
  # algebra installed as instance methods.
  #
  # Relation values can be obtained in various ways, for example by invoking
  # a relational operator on an existing relation. Relation literals are simply
  # constructed as follows:
  #
  #     Alf::Relation[
  #       # ... a comma list of ruby hashes ...
  #     ]
  #
  # See main Alf documentation about relational operators.
  #
  class Relation
    include Iterator
    
    protected
    
    # @return [Set] the set of tuples
    attr_reader :tuples
    
    public
    
    #
    # Creates a Relation instance.
    #
    # @param [Set] tuples a set of tuples
    #
    def initialize(tuples)
      raise ArgumentError unless tuples.is_a?(Set)
      @tuples = tuples
    end
    
    #
    # Coerces `val` to a relation.
    #
    # Recognized arguments are: Relation (identity coercion), Set of ruby hashes, 
    # Array of ruby hashes, Alf::Iterator.
    #
    # @return [Relation] a relation instance for the given set of tuples
    # @raise [ArgumentError] when `val` is not recognized
    #
    def self.coerce(val)
      case val
      when Relation
        val
      when Set
        Relation.new(val)
      when Array
        Relation.new val.to_set
      when Iterator
        Relation.new val.to_set
      else
        raise ArgumentError, "Unable to coerce #{val} to a Relation"
      end
    end
    
    # (see Relation.coerce)
    def self.[](*tuples)
      coerce(tuples)
    end
    
    #
    # (see Iterator#each)
    #
    def each(&block)
      tuples.each(&block)
    end
    
    #
    # Returns relation's cardinality (number of tuples).
    #
    # @return [Integer] relation's cardinality 
    # 
    def cardinality
      tuples.size
    end
    alias :size :cardinality
    alias :count :cardinality
    
    # Returns true if this relation is empty
    def empty?
      cardinality == 0
    end
    
    # 
    # Install the DSL through iteration over defined operators
    #
    Operator::each do |op_class|
      meth_name = Tools.ruby_case(Tools.class_name(op_class)).to_sym
      if op_class.unary?
        define_method(meth_name) do |*args|
          op = op_class.new(*args).pipe(self)
          Relation.coerce(op)
        end
      elsif op_class.binary?
        define_method(meth_name) do |right, *args|
          op = op_class.new(*args).pipe([self, Iterator.coerce(right)])
          Relation.coerce(op)
        end
      else
        raise "Unexpected operator #{op_class}"
      end
    end # Operators::each
      
    alias :+ :union
    alias :- :minus

    # Shortcut for project(attributes, true)
    def allbut(attributes)
      project(attributes, true)
    end
        
    #
    # (see Object#hash)
    #
    def hash
      @tuples.hash
    end
    
    #
    # (see Object#==)
    #
    def ==(other)
      return nil unless other.is_a?(Relation)
      other.tuples == self.tuples
    end
    alias :eql? :==
    
    #
    # Returns a textual representation of this relation
    #
    def to_s
      Alf::Renderer.text(self).execute("")
    end
    
    #
    # Returns a  literal representation of this relation
    #
    def inspect
      "Alf::Relation[" << @tuples.collect{|t| t.inspect}.join(',') << "]"
    end
  
    DEE = Relation.coerce([{}])
    DUM = Relation.coerce([])
  end # class Relation

  # Implements a small LISP-like DSL on top of Alf.
  #
  # The lispy dialect is the functional one used in .alf files and in compiled
  # expressions as below:
  #
  #   Alf.lispy.compile do
  #     (restrict :suppliers, lambda{ city == 'London' })
  #   end
  #
  # The DSL this module provides is part of Alf's public API and won't be broken 
  # without a major version change. The module itself and its inclusion pre-
  # conditions are not part of the DSL itself, thus not considered as part of 
  # the API, and may therefore evolve at any time. In other words, this module 
  # is not intended to be directly included by third-party classes. 
  #
  module Lispy
    
    alias :ruby_extend :extend
    
    # The environment
    attr_accessor :environment
    
    #
    # Compiles a query expression given by a String or a block and returns
    # the result (typically a tuple iterator)
    #
    # Example
    #
    #   # with a string
    #   op = compile "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   op = compile {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    #
    # @param [String] expr a Lispy expression to compile
    # @return [Iterator] the iterator resulting from compilation
    #
    def compile(expr = nil, path = nil, &block)
      if expr.nil? 
        instance_eval(&block)
      else 
        b = _clean_binding
        (path ? Kernel.eval(expr, b, path) : Kernel.eval(expr, b))
      end
    end
  
    #
    # Evaluates a query expression given by a String or a block and returns
    # the result as an in-memory relation (Alf::Relation)
    #
    # Example:
    #
    #   # with a string
    #   rel = evaluate "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   rel = evaluate {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    #
    def evaluate(expr = nil, path = nil, &block)
      compile(expr, path, &block).to_rel
    end
    
    #
    # Delegated to the current environment
    #
    # This method returns the dataset associated to a given name. The result
    # may depend on the current environment, but is generally an Iterator, 
    # often a Reader instance.
    #
    # @param [Symbol] name name of the dataset to retrieve
    # @return [Iterator] the dataset as an iterator
    # @see Environment#dataset
    #
    def dataset(name)
      raise "Environment not set" unless @environment
      @environment.dataset(name)
    end

    # Functional equivalent to Alf::Relation[...]
    def relation(*tuples)
      Relation.coerce(tuples)
    end
   
    # 
    # Install the DSL through iteration over defined operators
    #
    Operator::each do |op_class|
      meth_name = Tools.ruby_case(Tools.class_name(op_class)).to_sym
      if op_class.unary?
        define_method(meth_name) do |child, *args|
          child = Iterator.coerce(child, environment)
          op_class.new(*args).pipe(child, environment)
        end
      elsif op_class.binary?
        define_method(meth_name) do |left, right, *args|
          operands = [left, right].collect{|x| Iterator.coerce(x, environment)}
          op_class.new(*args).pipe(operands, environment)
        end
      else
        raise "Unexpected operator #{op_class}"
      end
    end # Operators::each
      
    def allbut(child, attributes)
      (project child, attributes, true)
    end
  
    Agg = Alf::Aggregator
    DUM = Relation::DUM
    DEE = Relation::DEE
    
    private 
    
    def _clean_binding
      binding
    end
    
  end # module Lispy

end # module Alf
require "alf/text"
require "alf/yaml"
require 'alf/heading'
require 'alf/sequel'
