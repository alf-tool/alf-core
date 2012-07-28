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

      def heading
        raise NotSupportedError unless @attributes[:heading]
        @attributes[:heading]
      end

      def keys
        @attributes[:keys] || Keys::EMPTY
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