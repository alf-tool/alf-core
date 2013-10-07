module Alf
  module Algebra
    class Join
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
          keys = []
          left.keys.each do |k1|
            right.keys.each do |k2|
              keys << (k1 | k2)
            end
          end
          Keys.new keys.uniq
        end
      end

    private

      def _type_check(options)
        joinable_headings!(left.heading, right.heading, options)
      end

    end # class Join
  end # module Algebra
end # module Alf
