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

    def self.type(heading)
      Class.new(Relation).extend(DomainMethods.new(Heading.coerce(heading)))
    end

    def self.new(tuples, type_info = nil)
      case type_info
      when Class
        super(tuples.map{|x| Tuple.coerce(x)}.to_set)
      when Hash, Heading
        Relation.type(type_info).new(tuples)
      when NilClass
        heading = Engine::InferHeading.new(tuples).first
        Relation.type(heading).new(tuples)
      else
        raise ArgumentError, "Invalid relation type `#{type_info}`"
      end
    end

    def self.super_domain_of?(x)
      x.is_a?(Class) && x.ancestors.include?(Relation)
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
        t.new(v)
      end
    end
    def self.[](*args); coerce(args); end

    class DomainMethods < Module

      def initialize(heading)
        define_method(:new){|tuples|
          super(tuples, self)
        }
        define_method(:heading){
          heading
        }
        define_method(:===){|value|
          super(value) ||
          (value.is_a?(Relation) && value.heading == heading)
        }
        define_method(:hash){
          @hash ||= 37*Relation.hash + heading.hash
        }
        define_method(:==){|other|
          other.is_a?(Class) && other.superclass==Relation && other.heading==heading
        }
        define_method(:coerce){|arg|
          Relation.coercions.apply(arg, self)
        }
        define_method(:to_s){
          "Relation.type(#{Support.to_ruby_literal(heading.to_hash)})"
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

    # Returns the attribute list, provided the relation contains at least one tuple.
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

    # Returns a hash code
    def hash
      @hash ||= 37*self.class.hash + tuples.hash
    end

    # Equality checking
    def ==(other)
      (self.class == other.class) && (self.tuples == other.tuples)
    end
    alias_method :eql?, :==

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
