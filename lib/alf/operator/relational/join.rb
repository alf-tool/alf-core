module Alf
  module Operator
    module Relational
      class Join
        include Operator, Relational, Binary

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
            keys.uniq
          end
        end

      end # class Join
    end # module Relational
  end # module Operator
end # module Alf
