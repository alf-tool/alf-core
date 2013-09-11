module Alf
  module Algebra
    class Intersect
      include Operator
      include Relational
      include Binary

      signature do |s|
      end

      def heading
        @heading ||= left.heading + right.heading
      end

      def keys
        @keys ||= begin
          k1s, k2s = left.keys, right.keys
          k2s = k2s.reject{|k| k1s.any?{|l| k.superset?(l) } }
          k1s = k1s.reject{|k| k2s.any?{|l| k.superset?(l) } }
          k1s + k2s
        end
      end

    end # class Intersect
  end # module Algebra
end # module Alf
