module Alf
  #
  # Namespace for all operators, relational and non-relational ones.
  #
  module Operator

    class << self
      include Tools::Registry

      # Installs the class methods needed on all operators
      def included(mod)
        super
        mod.extend(ClassMethods)
        register(mod, Operator)
      end
    end # class << self

    # @param [Array] operands Operator operands
    attr_accessor :operands

    # Create an operator instance
    def initialize(*args)
      signature.parse_args(args, self)
    end

    # @return [Signature] the operator signature.
    def signature
      self.class.signature
    end

    def to_s
      Tools.to_lispy(self) rescue super
    end

    def ==(other)
      (other.class == self.class) &&
      (other.operands == self.operands) &&
      (other.signature.collect_on(self) == self.signature.collect_on(self))
    end

  ### rewriting utils (careful to clean state-full information here!)

    def dup
      super.tap do |copy|
        yield(copy) if block_given?
        copy.clean_computed_attributes!
      end
    end

    def with_operands(*operands)
      dup{|copy| copy.operands = operands}
    end

  protected

    def clean_computed_attributes!
      @heading = nil
      @keys = nil
    end

  end # module Operator
end # module Alf
require_relative 'operator/class_methods'
require_relative 'operator/signature'

require_relative 'operator/var_ref'
require_relative 'operator/nullary'
require_relative 'operator/unary'
require_relative 'operator/binary'
require_relative 'operator/experimental'
