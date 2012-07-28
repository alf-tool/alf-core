module Alf
  module Tools
    class FakeOperand

      def initialize(context = nil)
        @context = context
        @attributes = {}
      end
      attr_reader :context

      def with_heading(h)
        dup.set!(:heading => Alf::Heading.coerce(h))
      end

      def with_keys(*keys)
        dup.set!(:keys => Alf::Keys.coerce(keys))
      end

      def each
      end

      def method_missing(name, *args, &bl)
        if args.empty? and bl.nil?
          @attributes.fetch(name) rescue super
        else
          super
        end
      end

      def to_lispy
        "a_fake_operand"
      end

    protected

      def set!(h)
        @attributes.merge!(h)
        self
      end

    end # class FakeOperand
  end # module Tools
end # module Alf