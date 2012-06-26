module Alf
  #
  # Namespace for all operators, relational and non-relational ones.
  #
  module Operator
    include Iterator, Tools

    class << self
      # Installs the class methods needed on all operators
      def included(mod)
        super
        mod.extend(ClassMethods)
      end

      # Yields non-relational then relational operators, in turn.
      def each
        Operator::NonRelational.each{|x| yield(x)}
        Operator::Relational.each{|x| yield(x)}
      end
    end # class << self

    # The context in which this operator has been constructed
    attr_accessor :context

    # @param [Array] operands Operator operands
    attr_accessor :operands

    # Create an operator instance
    def initialize(context, *args)
      @context = context
      signature.parse_args(args, self)
    end

    # @return [Signature] the operator signature.
    def signature
      self.class.signature
    end

    # Yields each tuple in turn
    def each(&block)
      compile(context).each(&block)
    end

  end # module Operator
end # module Alf
require_relative 'operator/class_methods'
require_relative 'operator/signature'

require_relative 'operator/nullary'
require_relative 'operator/unary'
require_relative 'operator/binary'
require_relative 'operator/experimental'

require_relative 'operator/non_relational'
require_relative 'operator/relational'
