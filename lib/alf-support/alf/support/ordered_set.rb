module Alf
  module Support
    module OrderedSet
      extend Domain::Reuse::Helpers

      reuse  :size, :each, :include?, :empty?, :to_a, :to_set, :first, :any?, :all?
      recoat :select, :reject

      def elements
        reused_instance
      end

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

      def map(&bl)
        self.class.new reused_instance.map(&bl).uniq
      end

      include Domain::Equalizer.new(:to_set)
    end # module OrderedSet
  end # module Support
end # module Alf