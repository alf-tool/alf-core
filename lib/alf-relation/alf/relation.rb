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
  #     Alf::Relation[
  #       # ... a comma list of ruby hashes ...
  #     ]
  #
  # See main Alf documentation about relational operators.
  #
  class Relation
    extend Domain::Reuse.new(::Set)
    include Algebra::Operand
    include Enumerable
    include Lang::ObjectOriented

    module GeneratorMethods

      def type(heading)
        heading = Heading.coerce(heading)
        meths   = DomainMethods.new(Relation, heading)
        Class.new(Relation).extend(meths)
      end
    end
    extend GeneratorMethods

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
      c.coercion(Enumerable) do |v,t|
        t = Relation.type(Engine::InferHeading.new(v).first) if Relation==t
        t.new(v)
      end
    end
    def self.[](*args); coerce(args); end

    class DomainMethods < Module

      def initialize(master_class, heading)
        define_method(:heading){
          heading
        }
        define_method(:<=>){|other|
          return nil unless other.ancestors.include?(master_class)
          heading <=> other.heading
        }
        define_method(:===){|value|
          super(value) ||
          (value.is_a?(master_class) && value.heading == heading)
        }
        define_method(:hash){
          @hash ||= 37*master_class.hash + heading.hash
        }
        define_method(:==){|other|
          other.is_a?(Class) && other.superclass==master_class && other.heading==heading
        }
        define_method(:coerce){|arg|
          master_class.coercions.apply(arg, self)
        }
        define_method(:to_s){
          "#{master_class.name}.type(#{Support.to_ruby_literal(heading.to_hash)})"
        }
      end
    end # module DomainMethods

    reuse :each, :size, :empty?
    alias_method :tuples, :reused_instance
    alias_method :cardinality, :size

    # Returns the relation heading
    def heading
      self.class.heading
    end

    # Returns the attribute list.
    def attribute_list
      heading.to_attr_list
    end

    # Returns a ReadOnly relvar
    def to_relvar
      Relvar::ReadOnly.new(self)
    end

    # Returns an engine Cog
    def to_cog
      Engine::Leaf.new(self)
    end

    # Returns a textual representation of this relation
    def to_s
      to_text
    end

    # Returns a  literal representation of this relation
    def to_ruby_literal
      "Alf::Relation[" +
        tuples.map{|t| Support.to_ruby_literal(t) }.join(', ') + "]"
    end
    alias :inspect :to_ruby_literal

    DUM_TYPE = DEE_TYPE = Relation.type(Heading.new({}))
    DUM = DUM_TYPE.new([])
    DEE = DEE_TYPE.new([{}])

  private

    def _operator_output(op)
      Engine::Compiler.new.call(op).to_relation
    end

    def _self_operand
      self
    end

  end # class Relation
end # module Alf
