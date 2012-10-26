module Alf
  module Algebra
    module Operator
      include Operand

    ### Class-based tools

      # Encapsulates method that allows making operator introspection, that is,
      # knowing operator cardinality and similar stuff.
      module ClassMethods

        # Returns the ruby case name of this operator
        def rubycase_name
          Support.rubycase_name(self)
        end

        # Installs or set the operator signature
        def signature
          if block_given?
            @signature = Signature.new(self, &Proc.new)
            @signature.install
          else
            @signature ||= Signature.new(self)
          end
        end

      end # module ClassMethods

      class << self
        include Support::Registry

        # Installs the class methods needed on all operators
        def included(mod)
          super
          mod.extend(ClassMethods)
          mod.extend(Classification)
          register(mod, Operator)
        end
      end # class << self

    ### PORO

      # @param [Array] operands Operator operands
      attr_accessor :operands

      # Create an operator instance
      def initialize(*args)
        signature.parse_args(args, self)
      end

      # Binds to a connection
      def bind(connection)
        super{|c| c.operands = operands.map{|op| op.bind(connection) } }
      end

      # @return [Signature] the operator signature.
      def signature
        self.class.signature
      end

    ### -> to_xxx

      def to_lispy
        cmdname  = self.class.rubycase_name
        oper, args, opts = signature.collect_on(self)
        args = opts.empty? ? (oper + args) : (oper + args + [ opts ])
        args = args.map{|arg| Support.to_lispy(arg) }
        "#{cmdname}(#{args.join(', ')})"
      end
      alias :to_s :to_lispy

      def to_relvar
        Relvar::Virtual.new(self, connection)
      end

    ### identity and pseudo-mutability

      def with_operands(*operands)
        dup{|copy|
          copy.operands = operands
          copy.clean_computed_attributes!
        }
      end

      def dup(&bl)
        bl.nil? ? super : super.tap(&bl)
      end

      def ==(other)
        (other.object_id == self.object_id) ||
        ((other.class == self.class) &&
         (other.operands == self.operands) &&
         (other.signature.collect_on(self) == self.signature.collect_on(self)))
      end

    protected

      def clean_computed_attributes!
        @heading = nil
        @common_heading = nil
        @common_attributes = nil
        @keys = nil
      end

    end # module Operator
  end # module Algebra
end # module Alf
require_relative 'operator/autonum'
require_relative 'operator/defaults'
require_relative 'operator/compact'
require_relative 'operator/sort'
require_relative 'operator/clip'
require_relative 'operator/coerce'
require_relative 'operator/type_check'
require_relative 'operator/generator'

require_relative 'operator/extend'
require_relative 'operator/project'
require_relative 'operator/restrict'
require_relative 'operator/rename'
require_relative 'operator/union'
require_relative 'operator/minus'
require_relative 'operator/intersect'
require_relative 'operator/join'
require_relative 'operator/matching'
require_relative 'operator/not_matching'
require_relative 'operator/wrap'
require_relative 'operator/unwrap'
require_relative 'operator/group'
require_relative 'operator/ungroup'
require_relative 'operator/summarize'
require_relative 'operator/rank'
require_relative 'operator/quota'
require_relative 'operator/infer_heading'
