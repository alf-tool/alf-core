module Alf
  module Support
    module OrderedSet
      extend Forwardable
      include Enumerable

      def_delegators :elements, :size, :each, :include?, :empty?, :to_a, :to_set

      def -(other)
        self.class.new (elements - self.class.coerce(other).elements)
      end

      def &(other)
        self.class.new (elements & self.class.coerce(other).elements)
      end

      def |(other)
        self.class.new (elements | self.class.coerce(other).elements)
      end
      alias_method :+, :|

      [ :select, :reject, :map ].each do |m|
        define_method(m) do |*args, &bl|
          self.class.new elements.send(m, *args, &bl).uniq
        end
      end

      def eql?(other)
        instance_of?(other.class) and to_set.eql?(other.to_set)
      end

      def ==(other)
        return false unless self.class <=> other.class
        to_set == other.to_set
      end

      def hash
        to_set.hash
      end

    end # module OrderedSet
  end # module Support
end # module Alf