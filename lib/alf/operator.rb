module Alf
  #
  # Namespace for all operators, relational and non-relational ones.
  #
  module Operator
    include Iterator, Tools

    # Yields non-relational then relational operators, in turn.
    def self.each
      Operator::NonRelational.each{|x| yield(x)}
      Operator::Relational.each{|x| yield(x)}
    end

    # Database that constructed this operator expression
    attr_accessor :database

    # @param [Array] operands Operator operands
    attr_accessor :operands

    # Create an operator instance
    def initialize(db, *args)
      raise ArgumentError, "Database expected, got `#{db}`" unless db.nil? or db.is_a?(Database)
      @database = db
      signature.parse_args(args, self)
    end

    # @return [Signature] the operator signature.
    def signature
      self.class.signature
    end

    # Yields each tuple in turn
    def each(&block)
      compile.each(&block)
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
