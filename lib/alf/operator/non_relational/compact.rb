module Alf
  module Operator
    module NonRelational
      class Compact
        include Operator, NonRelational, Unary

        signature do |s|
        end

        def heading
          @heading ||= operand.heading
        end

        def keys
          @keys ||= begin
            op_keys = operand.keys
            op_keys.empty? ? [ heading.to_attr_list ] : op_keys
          end
        end

      end # class Compact
    end # module NonRelational
  end # module Operator
end # module Alf
