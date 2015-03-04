module Alf
  module Algebra
    module Operator
      include Operand
      include TypeCheck

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

      # @return [Signature] the operator signature.
      def signature
        self.class.signature
      end

    ### heading, keys, and others

      def type_check(options = {strict: false})
        operands.each{|op| op.type_check(options) }
        _type_check(options)
        heading
      end

    ### -> to_xxx

      def to_cog(plan = nil)
        plan ? plan.compile(self) : Alf::Compiler::Default.new.call(self)
      end

      def to_s
        label = ""
        label << self.class.rubycase_name.to_s
        label << "(..."
        datasets, arguments, options = signature.collect_on(self)
        arguments.each_with_index do |arg,i|
          label << ", "
          label << Alf::Support.to_lispy(arg, "[native]")
        end
        unless options.nil? or options.empty?
          label << ", "
          label << Alf::Support.to_lispy(options, "[native]")
        end
        label << ")"
        label
      end

      def to_lispy
        cmdname  = self.class.rubycase_name
        oper, args, opts = signature.collect_on(self)
        args = opts.empty? ? (oper + args) : (oper + args + [ opts ])
        args = args.map{|arg| Support.to_lispy(arg) }
        "#{cmdname}(#{args.join(', ')})"
      end

      def to_relvar
        Relvar::Virtual.new(self)
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

      def hash
        @hash ||= [ self.class,
                    operands,
                    signature.collect_on(self) ].hash
      end

      def ==(other)
        super || ((other.class == self.class) &&
                  (other.signature.collect_on(other) == self.signature.collect_on(self)))
      end
      alias :eql? :==

    protected

      def clean_computed_attributes!
        @hash = nil
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
require_relative 'operator/generator'

require_relative 'operator/extend'
require_relative 'operator/frame'
require_relative 'operator/hierarchize'
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
require_relative 'operator/page'
require_relative 'operator/quota'
require_relative 'operator/image'
