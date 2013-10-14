require_relative 'tuple'
module Alf
  #
  # Defines an in-memory relation data structure.
  #
  # A relation is a set of tuples; a tuple is a set of attribute (name, value) pairs. The
  # class implements such a data structure with full relational algebra installed as
  # instance methods.
  #
  # Relation values can be obtained in various ways, for example by invoking a relational
  # operator on an existing relation. Relation literals are simply constructed as follows:
  #
  #     Alf::Relation([
  #       # ... a comma list of ruby hashes ...
  #     ])
  #
  # See main Alf documentation about relational operators.
  #
  class Relation
    extend Domain::Reuse.new(::Set)
    extend Domain::HeadingBased.new(self)
    include Algebra::Operand
    include Enumerable
    include Lang::ObjectOriented

    def initialize(tuples)
      super(tuples.map{|x| Tuple.coerce(x)}.to_set)
    end

    coercions do |c|
      c.delegate :to_relation
      c.coercion(Hash) do |v,t|
        throw :next_rule unless v.size==1 and v.values.first.is_a?(Array)
        key, values = v.to_a.first
        c.coerce(values.map{|value| {key.to_sym => value} }, t)
      end
      c.coercion(TupleLike) do |v,t|
        c.coerce([v], t)
      end
      c.coercion(Path.like) do |v,t|
        c.coerce(Alf.reader(v).to_set, t)
      end
      c.coercion(Enumerable) do |v,rt|
        rt = Relation[Engine::InferHeading.new(v).first] if Relation==rt
        tt = rt.generating_type.is_a?(Class) ? rt.generating_type : Tuple[rt.heading]
        rt.new(v.map{|t| tt.coerce(t) }.to_set).check_internal_representation!
      end
    end

    def self.empty
      @empty ||= new([].to_set)
    end

    def check_internal_representation!
      error = lambda{|msg| raise TypeError, msg }
      error["Set expected"]        unless reused_instance.is_a?(Set)
      error["Superclass mismatch"] unless self.class.superclass == Relation
      self
    end

    reuse :each, :size, :empty?
    alias_method :tuples, :reused_instance
    alias_method :cardinality, :size

    def [](*args)
      attrs = args.map{|arg| arg.is_a?(Hash) ? arg.keys : arg }.flatten
      handler = ->(v){ v.is_a?(Symbol) ? ->{ __send__(v) } : v }
      extension = args.each_with_object({}) do |arg, ext|
        case arg
        when Symbol
          ext[arg] = handler[arg]
        when Hash
          arg.each_pair do |k,v|
            ext[k] = handler[v]
          end
        end
      end
      self.extend(extension).project(attrs)
    end

    # Returns the relation heading
    def heading
      self.class.heading
    end

    # Returns the attribute list.
    def to_attr_list
      heading.to_attr_list
    end

    # Returns self
    def to_relation
      self
    end

    # Returns a ReadOnly relvar
    def to_relvar
      Relvar::ReadOnly.new(self)
    end

    # Returns an engine Cog
    def to_cog(plan = nil)
      Engine::Leaf.new(self, self)
    end

    def to_hash(from, to=nil)
      if from.is_a?(Hash) and to.nil?
        raise ArgumentError "Hash of size 1 expected. " unless from.size==1
        to_hash(from.keys.first, from.values.first)
      else
        each.each_with_object({}) do |tuple, hash|
          key, value = tuple[from], tuple[to]
          if hash.has_key?(key) and hash[key] != value
            raise "Key expected for `#{from}`, divergence found on `#{key}`"
          else
            hash[key] = value
          end
        end
      end
    end

    # Returns a textual representation of this relation
    def to_s
      to_text
    end

    # Returns a  literal representation of this relation
    def to_ruby_literal
      "Alf::Relation([" + tuples.map{|t| Support.to_ruby_literal(t) }.join(', ') + "])"
    end
    alias :inspect :to_ruby_literal

    DUM_TYPE = DEE_TYPE = Relation[{}]
    DUM = DUM_TYPE.new([])
    DEE = DEE_TYPE.new([{}])

  private

    def _operator_output(op)
      op.to_relation
    end

    def _self_operand
      Algebra::Operand::Proxy.new(self)
    end

  end # class Relation
end # module Alf
