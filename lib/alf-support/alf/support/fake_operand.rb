module Alf
  module Support
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

      def with_name(name)
        dup.set!(:name => name.to_sym)
      end

      def each
      end

      def name
        @attributes[:name] || "a_fake_operand"
      end

      def heading
        @attributes[:heading] || context.heading(name)
      end

      def keys
        @attributes[:keys] || Keys::EMPTY
      end

      def delete(predicate)
        context.delete(name, predicate)
      end

      def insert(inserted)
        context.insert(name, inserted)
      end

      def update(updating, predicate)
        context.update(name, updating, predicate)
      end

      def to_lispy
        name
      end

    protected

      def set!(h)
        @attributes.merge!(h)
        self
      end

    end # class FakeOperand
  end # module Support
end # module Alf